import { Point } from '@influxdata/influxdb-client'
import { write } from '../database/influx'

export class Measurement {
  timestamp: number
  current: number
  tension: number
  sensor_id: string

  constructor({
    current,
    tension,
    sensor_id,
  }: {
    current: number
    tension: number
    sensor_id: string
  }) {
    this.timestamp = Date.now()
    this.current = current
    this.tension = tension
    this.sensor_id = sensor_id
  }

  toObject() {
    return {
      current: this.current,
      tension: this.tension,
      sensor_id: this.sensor_id,
    }
  }

  toInfluxPoint() {
    return new Point('measurement')
      .timestamp(this.timestamp)
      .floatField('tension', this.tension)
      .floatField('current', this.current)
      .tag('sensor_id', this.sensor_id)
  }

  writeToDatabase() {
    write(this.toInfluxPoint())
  }
}
