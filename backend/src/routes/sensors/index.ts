import { Router } from 'express'
import { getUserSensors } from './get_user_sensors'
import { getSensor } from './get_sensor'

export const router = Router()
  .get('/:sensorId', getSensor)
  .get('/user/:userId', getUserSensors)
