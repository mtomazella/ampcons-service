import { RawRecord } from '.'

export const aggregatePointsMapper = (data: RawRecord[]) => {
  type NewRecord = { time: string; sensor_id: string }
  const aggregatedData: Record<string, NewRecord> = {}

  data.forEach(({ _time, _value, _field, sensor_id }) => {
    const key = `${_time}#${sensor_id}`
    aggregatedData[key] = {
      ...aggregatedData[key],
      time: _time,
      sensor_id,
      [_field]: _value,
    }
  })

  return Object.values(aggregatedData).sort((r1: NewRecord, r2: NewRecord) => {
    return new Date(r1.time).getTime() - new Date(r2.time).getTime()
  })
}
