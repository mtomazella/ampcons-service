import { ParameterizedQuery, flux } from '@influxdata/influxdb-client'
import { globalConfig } from '../../config'

export type MeasurementField = 'tension' | 'current'
export type MeasurementTag = 'sensor_id'

export type InfluxDate = Date | 'now'
export type InfluxDuration = string

export class MeasurementQueryBuilder {
  private query: string[] = []

  private measurementFields: MeasurementField[] = ['current', 'tension']
  private tagFields: MeasurementTag[] = ['sensor_id']

  private timeUpperBound: InfluxDate | undefined = 'now'
  private timeOffset: InfluxDuration | undefined = '-1d'
  private useMean: boolean = false

  filterSensorIds(sensorIds: string[]) {
    throw 'Not Implemented'
    return this
  }

  rangeWithOffset({
    fluxOffset,
  }: {
    // timeLowerBound?: InfluxDate
    // timeUpperBound?: InfluxDate
    fluxOffset: InfluxDuration
  }) {
    if (this.timeUpperBound === 'now')
      this.query.push(`range(start: ${fluxOffset})`)

    return this
  }

  group({ columns }: { columns: ('_field' | MeasurementTag)[] }) {
    this.query.push(
      `group(${
        columns ? `columns: [${columns.map(c => `"${c}"`).join(', ')}]` : ''
      })`,
    )
    return this
  }

  mean() {
    this.query.push('mean()')
    return this
  }

  sum() {
    this.query.push('sum()')
    return this
  }

  filterFields(fields: MeasurementField[]) {
    this.query.push(
      `filter(fn: (r) => ${fields
        .map(field => `r._field == "${field}"`)
        .join(' or ')})`,
    )
    return this
  }

  build() {
    return `${[
      `from(bucket: "${globalConfig.BE_INFLUXDB_MEASUREMENTS_BUCKET}")`,
      ...this.query,
    ]
      .filter(q => q !== null)
      .join('\n |> ')}`
  }
}

export const buildSummaryQuery = ({
  timeOffset = '-1m',
}: {
  timeOffset?: string
}) => {
  return `
    data = from(bucket: "${globalConfig.BE_INFLUXDB_MEASUREMENTS_BUCKET}")
      |> range(start: ${timeOffset})
      |> aggregateWindow(every: 1s, fn: mean, createEmpty: false)

    data
      |> filter(fn: (r) => r["_field"] == "current")
      |> group(columns: ["_field", "sensor_id"])
      |> mean()
      |> group(columns: ["_field"])
      |> sum()
      |> map(fn: (r) => ({ r with current: r["_value"]}))
      |> drop(columns: ["_field", "_value"])
      |> yield(name: "current")

    data
      |> filter(fn: (r) => r["_field"] == "current" or r["_field"] == "tension")
      |> group(columns: ["_time", "sensor_id"])
      |> pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value")
      |> map(fn: (r) => ({ r with power: r.current * r.tension }))
      |> aggregateWindow(every: 1d, column: "power", fn: mean)
      |> group(columns: ["sensor_id"])
      |> mean(column: "power")
      |> group()
      |> sum(column: "power")
      |> yield(name: "mean")
  `
}
