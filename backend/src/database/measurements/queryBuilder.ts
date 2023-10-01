import { ParameterizedQuery, flux } from '@influxdata/influxdb-client'
import { globalConfig } from '../../config'

export type InfluxDate = Date | 'now'
export type InfluxDuration = string

export class MeasurementQueryBuilder {
  private measurementFields = ['current', 'tension']
  private tagFields = ['sensor_id']

  private sensorIds: string[] | undefined
  private timeLowerBound: InfluxDate | undefined
  private timeUpperBound: InfluxDate | undefined = 'now'
  private timeOffset: InfluxDuration | undefined = '-1d'
  private useMean: boolean = false

  useSensorIds(sensorIds: string[]) {
    this.sensorIds = sensorIds
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

  mean() {
    this.useMean = true
    return this
  }

  private buildTime() {
    if (this.timeUpperBound === 'now') return `range(start: ${this.timeOffset})`
    throw 'This time of time bound was not implemented yet'
  }

  private buildMean() {
    if (!this.useMean) return null
    return 'group(columns: ["_field"]) |> mean()'
  }

  build() {
    // return `
    //   from(bucket: "measurements")
    // |> range(start: -1d)
    //   `
    return `${[
      `from(bucket: "${globalConfig.BE_INFLUXDB_MEASUREMENTS_BUCKET}")`,
      this.buildTime(),
      this.buildMean(),
    ]
      .filter(q => q !== null)
      .join('\n |> ')}`
  }
}
