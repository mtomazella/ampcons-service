import dotenv from 'dotenv'
import { pick } from 'lodash'

export const initConfiguration = () => {
  dotenv.config()
  const debugEnvPath = process.env.DEBUG_ENV_PATH
  if (debugEnvPath) dotenv.config({ path: debugEnvPath })
}

export const getGlobalConfig = (): Record<string, any> => {
  return pick(process.env, [
    'BE_INFLUXDB_URL',
    'BE_INFLUXDB_MEASUREMENTS_BUCKET',
    'BE_INFLUXDB_ORG',
    'BE_INFLUXDB_TOKEN',
  ])
}

export const globalConfig = getGlobalConfig()
