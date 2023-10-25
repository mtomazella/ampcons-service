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

    const { offset, interval, sensorIds } = parseParameters(
      request.query as RequestQuery,
    )

    const queryString = buildPointGatherQuery({
      timeOffset: offset as string,
      aggregationInterval:
        interval ?? autodefineAggregationInterval({ offset: offset as string }),
      sensorIds,
    })
    const queryResult = await query(queryString)

    return Success(response, {
      data: (queryResult as Record<string, any>[]).map(
        ({ _time, table, result, _start, _stop, ...other }) => ({
          time: _time,
          displayTime: new Date(_time).toLocaleDateString(),
          ...other,
        }),
      ),
    })
  } catch (error) {
    return InternalServerError(response, error)
  }
}

const parseParameters = (params: RequestQuery | undefined) => {
  const { offset, sensorIds, interval } = params ?? {}
  return {
    offset: offset ?? '-1m',
    sensorIds: parseStringList(sensorIds),
    interval: interval ?? '1m',
  }
}
