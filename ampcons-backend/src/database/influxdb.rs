use influxdb_rs::{
    data_model::query::ReadQuery,
    reqwest::{Response, Url},
    Client, Error, Point, Precision,
};
use std::env::var;

async fn get_client() -> Result<Client, Error> {
    let influx_url: Url = Url::parse(
        var("BE_INFLUXDB_URL")
            .unwrap_or_else(|_| "http://localhost:8086".to_string())
            .as_str(),
    )
    .unwrap();

    let influx_bucket: String =
        var("BE_INFLUXDB_MEASUREMENTS_BUCKET").unwrap_or_else(|_| "measurements".to_string());

    let influx_org: String = var("BE_INFLUXDB_ORG").unwrap_or_else(|_| "ampcons".to_string());

    let influx_token: String =
        var("BE_INFLUXDB_TOKEN").unwrap_or_else(|_| "ampcons_admin_token".to_string());

    Client::new(influx_url, influx_bucket, influx_org, influx_token).await
}

pub async fn write(point: Point<'static>) -> Result<(), Error> {
    let client = get_client().await;
    if client.is_err() {
        return Err(client.unwrap_err());
    }
    client
        .unwrap()
        .write_point(point, Some(Precision::Seconds), None)
        .await
}

pub async fn read(query: ReadQuery) -> Result<Response, Error> {
    let client = get_client().await;
    if client.is_err() {
        return Err(client.unwrap_err());
    }
    client.unwrap().query(Option::Some(query)).await
}
