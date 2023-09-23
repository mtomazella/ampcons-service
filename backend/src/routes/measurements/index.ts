import { Router } from 'express'
import { insertMeasurement } from './insert_measurement'
import { getMeasurements } from './get_measurements'

export const router = Router()
  .post('/', insertMeasurement)
  .get('/', getMeasurements)
