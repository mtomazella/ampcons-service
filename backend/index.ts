import express, { Request, Response } from 'express'
import { initConfiguration } from './src/config'
import { router as measurementsRouter } from './src/routes/measurements'
import { router as userRouter } from './src/routes/users'
import { router as sensorRouter } from './src/routes/sensors'

initConfiguration()

const app = express()

app.use(express.json())

app
  .get('/ping', (req: Request, res: Response) => {
    res.json({
      connection: true,
      message: req.query.message,
    })
  })
  .use('/measurements', measurementsRouter)
  .use('/user', userRouter)
  .use('/sensor', sensorRouter)

app.listen(3001, () => console.log('Server up'))
