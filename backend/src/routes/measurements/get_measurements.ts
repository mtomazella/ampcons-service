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
  MeasurementQueryBuilder,
  RawRecord,
  aggregatePointsMapper,
} from '../../database/measurements'

export const getMeasurements = async (request: Request, response: Response) => {
  try {
    const { hasError, missing } = validateParameters(request.query, [])
    if (hasError)
      return BadRequest(response, buildMissingParamErrorString(missing))

    const { offset = '-1d' } = request.query

    const queryString = new MeasurementQueryBuilder()
      .rangeWithOffset({ fluxOffset: offset as string })
      .build()
    const queryResult = await query(queryString)

    return Success(response, {
      data: aggregatePointsMapper(queryResult as RawRecord[]) ?? [],
    })
  } catch (error) {
    return InternalServerError(response, error)
  }
}
