import express, { Request, Response } from 'express'
import { router as measurementsRouter } from './src/routes/measurements'
import { globalConfig, initConfiguration } from './src/config'

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

app.listen(3001, () => console.log('Server up'))
