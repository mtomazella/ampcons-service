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

export const getSummary = async (request: Request, response: Response) => {
  try {
    const { hasError: hasErrorParams, missing: missingParams } =
      validateParameters(request.params, ['userId'])
    if (hasErrorParams)
      return BadRequest(response, buildMissingParamErrorString(missingParams))
    const { hasError, missing } = validateParameters(request.query, [])
    if (hasError)
      return BadRequest(response, buildMissingParamErrorString(missing))

    const { offset = '-1m' } = request.query

    const queryString = new MeasurementQueryBuilder()
      .useTimeWithOffset({ fluxOffset: offset as string })
      .mean()
      .build()
    const queryResult = await query(queryString)

    return Success(
      response,
      aggregatePointsMapper(queryResult as RawRecord[])[0] ?? {},
    )
  } catch (error) {
    return InternalServerError(response, error)
  }
}
