import { ParameterizedQuery, flux } from '@influxdata/influxdb-client'
import { globalConfig } from '../../config'

export type InfluxDate = Date | 'now'
export type InfluxDuration = string

export class MeasurementQueryBuilder {
  private sensorId: string | undefined
  private timeLowerBound: InfluxDate | undefined
  private timeUpperBound: InfluxDate | undefined = 'now'
  private timeOffset: InfluxDuration | undefined = '-1d'

  useSensorId(sensorId: string) {
    this.sensorId = sensorId
    return this
  }

  useTimeBounds({
    timeLowerBound,
    timeUpperBound,
  }: {
    timeLowerBound: InfluxDate
    timeUpperBound: InfluxDate
  }) {
    this.timeOffset = undefined
    this.timeLowerBound = timeLowerBound
    this.timeUpperBound = timeUpperBound
    return this
  }

  /**
   * Offset is a duration in milliseconds
   */
  useTimeWithOffset({
    timeLowerBound,
    timeUpperBound,
    fluxOffset,
  }: {
    timeLowerBound?: InfluxDate
    timeUpperBound?: InfluxDate
    fluxOffset: InfluxDuration
  }) {
    if (timeLowerBound && timeUpperBound)
      throw 'Choose only one bound to define'

    if (timeLowerBound) this.timeLowerBound = timeLowerBound
    else if (timeUpperBound) this.timeUpperBound = timeUpperBound

    this.timeOffset = fluxOffset

    return this
  }

  buildTime() {
    if (this.timeUpperBound === 'now') return `range(start: ${this.timeOffset})`
    throw 'This time of time bound was not implemented yet'
  }

  build() {
    // return `
    //   from(bucket: "measurements")
    // |> range(start: -1d)
    //   `
    return `${[
      `from(bucket: "${globalConfig.BE_INFLUXDB_MEASUREMENTS_BUCKET}")`,
      this.buildTime(),
    ]
      .filter(q => q !== null)
      .join('\n |> ')}`
  }
}
