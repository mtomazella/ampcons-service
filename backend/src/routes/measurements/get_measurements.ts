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
  buildPointGatherQuery,
} from '../../database/measurements'

export const getMeasurements = async (request: Request, response: Response) => {
  try {
    const { hasError, missing } = validateParameters(request.query, [])
    if (hasError)
      return BadRequest(response, buildMissingParamErrorString(missing))

    const { offset = '-1d' } = request.query

    const queryString = buildPointGatherQuery({ timeOffset: offset as string })
    const queryResult = await query(queryString)

    return Success(response, {
        data: (queryResult as Record<string, any>[]).map(({ _time, table, result, _start, _stop, ...other }) => ({ time: _time, ...other }))
    })
  } catch (error) {
    return InternalServerError(response, error)
  }
}
