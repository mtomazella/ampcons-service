import { Router } from 'express'
import { getUser } from './get_user'

export const router = Router().get('/:userId', getUser)
