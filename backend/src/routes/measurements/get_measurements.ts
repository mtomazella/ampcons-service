import { Request, Response } from 'express'
import { validateParameters } from '../../utils/validate_parameters'
import {
  BadRequest,
  InternalServerError,
  Success,
} from '../../utils/response_builder'
import { buildMissingParamErrorString } from '../../utils/string_builders'
import { query } from '../../database/influx'
import {
  autodefineAggregationInterval,
  buildPointGatherQuery,
  buildPowerOfMonthQuery,
} from '../../database/measurements'
import { StringList } from '../../types/requests'
import { parseStringList } from '../../utils/string_parsers'

type RequestQuery = {
  offset: string | undefined
  interval: string | undefined
  sensorIds: StringList | undefined
}

export const getMeasurements = async (request: Request, response: Response) => {
  try {
    const { hasError, missing } = validateParameters(request.query, [])
    if (hasError)
      return BadRequest(response, buildMissingParamErrorString(missing))

    const parsedParams = parseParameters(request.query as RequestQuery)
    const { offset, interval, sensorIds } = parsedParams

    const queryString = buildPointGatherQuery({
      timeOffset: offset as string,
      aggregationInterval:
        interval ?? autodefineAggregationInterval({ offset: offset as string }),
      sensorIds,
    })
    // return Success(response, { queryString })
    const queryResult = await query(queryString)

    // const queryResult = (
    //   (await query(buildPowerOfMonthQuery({ sensorIds }))) as Record<
    //     string,
    //     any
    //   >[]
    // ).reduce(
    //   (current, element) => {
    //     if (element.result === 'graph') {
    //       current.points.push(element)
    //       return current
    //     }
    //     if (element.result === 'absolute') {
    //       current.total = element._value
    //       return current
    //     }
    //     return current
    //   },
    //   { points: [], total: -1 },
    // )

    return Success(response, {
      meta: parsedParams,
      data: (queryResult as Record<string, any>[]).map(
        ({ _time, table, result, _start, _stop, ...other }) => ({
          time: _time,
          displayTime: new Date(_time).toLocaleDateString(),
          ...other,
        }),
      ),
      // data: (queryResult.points as Record<string, any>[]).map(
      //   ({
      //     _time,
      //     table,
      //     result,
      //     _start,
      //     _stop,
      //     _value,
      //     _field,
      //     ...other
      //   }) => ({
      //     time: _time,
      //     displayTime: new Date(_time).toLocaleDateString(),
      //     power: _value,
      //     ...other,
      //   }),
      // ),
    })
  } catch (error) {
    return InternalServerError(response, error)
  }
}

const parseParameters = (params: RequestQuery | undefined) => {
  const { offset, sensorIds, interval } = params ?? {}
  return {
    offset: offset ?? '-1d',
    sensorIds: parseStringList(sensorIds),
    interval: interval,
  }
}
