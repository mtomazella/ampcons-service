import { Router } from 'express'
import { insertMeasurement } from './insert_measurement'

export const router = Router().post('/', insertMeasurement)
