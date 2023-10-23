import { Router } from 'express'
import { getSensors } from './get_sensors'

export const router = Router().get('/user/:userId', getSensors)
