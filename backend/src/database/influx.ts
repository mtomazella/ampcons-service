import {
  InfluxDB,
  ParameterizedQuery,
  Point,
  flux,
} from '@influxdata/influxdb-client'
import { globalConfig } from '../config'

const getInstance = () => {
  return new InfluxDB({
    url: globalConfig.BE_INFLUXDB_URL,
    token: globalConfig.BE_INFLUXDB_TOKEN,
  })
}

export const write = async (point: Point) => {
  const writeApi = getInstance().getWriteApi(
    globalConfig.BE_INFLUXDB_ORG,
    globalConfig.BE_INFLUXDB_MEASUREMENTS_BUCKET,
    'ms',
  )

  writeApi.writePoint(point)

  await writeApi.close()
}

export const query = async (query: string) => {
  const queryApi = getInstance().getQueryApi(globalConfig.BE_INFLUXDB_ORG)

  const result = await queryApi
    .collectRows(query)
    .catch(error => console.error(error))

  return result
}
