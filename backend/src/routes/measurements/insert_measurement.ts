import { Request, Response } from 'express'
import { validateParameters } from '../../utils/validate_parameters'
import { BadRequest, Created, Success } from '../../utils/response_builder'
import { buildMissingParamErrorString } from '../../utils/string_builders'
import { pick } from 'lodash'
import { Measurement } from '../../data/measurement'

export const insertMeasurement = async (
  request: Request,
  response: Response,
) => {
  const { hasError, missing } = validateParameters(request.body, [
    'tension',
    'current',
    'sensor_id',
  ])
  if (hasError)
    return BadRequest(response, buildMissingParamErrorString(missing))

  const recordToAdd = new Measurement(
    pick(request.body, ['tension', 'current', 'sensor_id']),
  )

  await recordToAdd.writeToDatabase()

  return Created(response, recordToAdd.toObject())
}
