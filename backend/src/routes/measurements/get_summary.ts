import { Request, Response } from 'express'
import { validateParameters } from '../../utils/validate_parameters'
import {
  BadRequest,
  InternalServerError,
  NoContent,
  Success,
} from '../../utils/response_builder'
import { buildMissingParamErrorString } from '../../utils/string_builders'
import { query } from '../../database/influx'
import {
  buildPowerOfMonthQuery,
  buildSummaryQuery,
} from '../../database/measurements'
import { isEmpty, omit } from 'lodash'
import { StringList } from '../../types/requests'
import { parseStringList } from '../../utils/string_parsers'

type RequestQuery = {
  offset: string | undefined
  sensorIds: StringList | undefined
}

export const getSummary = async (request: Request, response: Response) => {
  try {
    const { hasError: hasErrorParams, missing: missingParams } =
      validateParameters(request.params, ['userId'])
    if (hasErrorParams)
      return BadRequest(response, buildMissingParamErrorString(missingParams))
    const { hasError, missing } = validateParameters(request.query, [])
    if (hasError)
      return BadRequest(response, buildMissingParamErrorString(missing))

    const { offset = '-1m', sensorIds } = parseParameters(
      request.query as RequestQuery,
    )

    const queryString = buildSummaryQuery({
      timeOffset: offset,
      sensorIds,
    })
    const queryResult = await query(queryString)

    // return Success(response, { queryResult })

    const summaryResults = { current: -1, power: -1 }
    ;(queryResult as Record<string, any>[]).forEach(element => {
      if (element.result === 'current') summaryResults.current = element.current
      if (element.result === 'mean' && element._field === 'power')
        summaryResults.power = element._value
    })

    const monthResults = (
      (await query(buildPowerOfMonthQuery({ sensorIds }))) as Record<
        string,
        any
      >[]
    ).reduce(
      (current, element) => {
        if (element.result === 'graph') {
          current.points.push(element)
          return current
        }
        if (element.result === 'absolute') {
          current.total = element._value
          return current
        }
        return current
      },
      { points: [], total: -1 },
    )

    if (isEmpty(summaryResults)) return NoContent(response)
    return Success(
      response,
      { ...summaryResults, monthConsumption: monthResults.total },
      // queryResult as Record<string, any>[]
    )
  } catch (error) {
    return InternalServerError(response, error)
  }
}

const parseParameters = (params: RequestQuery | undefined) => {
  const { offset, sensorIds } = params ?? {}
  return {
    offset: offset ?? '-1m',
    sensorIds: parseStringList(sensorIds),
  }
}
