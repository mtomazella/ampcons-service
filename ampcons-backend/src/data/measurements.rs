use crate::database;
use chrono::Utc;
use influxdb::InfluxDbWriteable;
use influxdb::{Error, Timestamp};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct RawMeasurement {
    tension: f64,
    current: f64,
    comp_id: String,
}

#[derive(Serialize)]
pub struct Measurement {
    time: i64,
    tension: f64,
    current: f64,
    power: f64,
    comp_id: String,
}
impl From<RawMeasurement> for Measurement {
    fn from(raw_measurement: RawMeasurement) -> Measurement {
        Measurement {
            time: (Utc::now().timestamp()),
            tension: (raw_measurement.tension),
            current: (raw_measurement.current),
            power: (raw_measurement.current * raw_measurement.tension),
            comp_id: raw_measurement.comp_id,
        }
    }
}
impl Measurement {
    pub async fn write(self) -> Result<String, Error> {
        let data_point = MeasurementDataPoint::from(self);
        let query = data_point.into_query("measurement");
        database::influxdb::write(query).await
    }
}

#[derive(InfluxDbWriteable)]
pub struct MeasurementDataPoint {
    time: Timestamp,
    tension: f64,
    current: f64,
    power: f64,
    #[influxdb(tag)]
    comp_id: String,
}
impl From<Measurement> for MeasurementDataPoint {
    fn from(measurement: Measurement) -> MeasurementDataPoint {
        MeasurementDataPoint {
            time: (Timestamp::Milliseconds(measurement.time as u128)),
            tension: (measurement.tension),
            current: (measurement.current),
            power: (measurement.power),
            comp_id: (measurement.comp_id),
        }
    }
}
