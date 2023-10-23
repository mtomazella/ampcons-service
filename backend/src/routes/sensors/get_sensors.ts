import { Request, Response } from 'express'
import { validateParameters } from '../../utils/validate_parameters'
import {
  BadRequest,
  InternalServerError,
  NoContent,
  Success,
} from '../../utils/response_builder'
import { buildMissingParamErrorString } from '../../utils/string_builders'
import { getUser as getUserDB } from '../../database/users'
import { getSensorList } from '../../database/sensors'
import { isEmpty } from 'lodash'

export const getSensors = async (request: Request, response: Response) => {
  try {
    const { hasError, missing } = validateParameters(request.params, ['userId'])
    if (hasError)
      return BadRequest(response, buildMissingParamErrorString(missing))

    const { userId } = request.params

    const user = await getUserDB(userId)
    if (!user) return BadRequest(response, 'User does not exist')
    if (!user.sensorIds || isEmpty(user.sensorIds)) return NoContent(response)

    const sensors = await getSensorList(user.sensorIds)

    return Success(response, { data: sensors })
  } catch (error) {
    return InternalServerError(response, error)
  }
}
