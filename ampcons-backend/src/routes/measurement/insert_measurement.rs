use axum::{extract::Json, http::StatusCode, response::IntoResponse};

use crate::{
    data::measurements::{Measurement, RawMeasurement},
    to_json,
    utils::route::get_response_for_influxdb_error,
};

pub async fn insert_measurement(Json(params): Json<RawMeasurement>) -> impl IntoResponse {
    let measurement = Measurement::from(params);
    let result = measurement.clone().write().await;
    if result.is_ok() {
        (StatusCode::OK, to_json!(measurement))
    } else {
        get_response_for_influxdb_error(result.unwrap_err())
    }
}
