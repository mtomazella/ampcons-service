import { Request, Response } from 'express'
import { validateParameters } from '../../utils/validate_parameters'
import {
  BadRequest,
  InternalServerError,
  NoContent,
  Success,
} from '../../utils/response_builder'
import { buildMissingParamErrorString } from '../../utils/string_builders'
import * as sensorDB from '../../database/sensors'
import { isEmpty } from 'lodash'

export const getSensor = async (request: Request, response: Response) => {
  try {
    const { hasError, missing } = validateParameters(request.params, [
      'sensorId',
    ])
    if (hasError)
      return BadRequest(response, buildMissingParamErrorString(missing))

    const { sensorId } = request.params

    const sensor = await sensorDB.getSensor(sensorId)
    if (!sensor) return NoContent(response)

    return Success(response, { data: sensor })
  } catch (error) {
    return InternalServerError(response, error)
  }
}
