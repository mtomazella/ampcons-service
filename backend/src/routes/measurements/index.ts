import { Router, request, response } from 'express'
import { insertMeasurement } from './insert_measurement'
import { getMeasurements } from './get_measurements'
import { getSummary } from './get_summary'

export const router = Router()
  .post('/', insertMeasurement)
  .get('/:userId', getMeasurements)
  .get('/:userId/summary', getSummary)
