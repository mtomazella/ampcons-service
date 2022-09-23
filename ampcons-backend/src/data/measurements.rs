use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct RawMeasurement {
    tension: u64,
    current: f64,
}

#[derive(Serialize)]
pub struct Measurement {
    timestamp: String,
    tension: u64,
    current: f64,
    power: f64,
}
impl From<RawMeasurement> for Measurement {
    fn from(raw_measurement: RawMeasurement) -> Measurement {
        Measurement {
            timestamp: ("38016739081".to_string()),
            tension: (raw_measurement.tension),
            current: (raw_measurement.current),
            power: (raw_measurement.current * raw_measurement.tension as f64),
        }
    }
}
