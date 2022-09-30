use influxdb::{Client, Error, WriteQuery};
use std::env::var;

fn get_client() -> Client {
    Client::new(
        var("BE_INFLUXDB_URL").unwrap_or_else(|_| "http://localhost:8086".to_string()),
        var("BE_INFLUXDB_MEASUREMENTS_BUCKET").unwrap_or_else(|_| "measurements".to_string()),
    )
}

pub async fn write(query: WriteQuery) -> Result<String, Error> {
    get_client().query(query).await
}
