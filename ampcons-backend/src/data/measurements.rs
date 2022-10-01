use crate::database;
use chrono::Utc;
use influxdb_rs::{Error, Point};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct RawMeasurement {
    tension: f64,
    current: f64,
    comp_id: String,
}

#[derive(Serialize, Clone)]
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
    pub fn to_data_point(self) -> Point<'static> {
        Point::new("measurement")
            .add_timestamp(self.time)
            .add_field("tension", self.tension)
            .add_field("current", self.current)
            .add_field("power", self.power)
            .add_tag("comp_id", self.comp_id)
    }

    pub async fn write(self) -> Result<(), Error> {
        database::influxdb::write(self.to_data_point()).await
    }
}
