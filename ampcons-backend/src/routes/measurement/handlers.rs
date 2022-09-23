use axum::{extract::Json, http::StatusCode, response::IntoResponse};

use crate::{
    data::measurements::{Measurement, RawMeasurement},
    to_json,
};

pub async fn insert_measurement(Json(params): Json<RawMeasurement>) -> impl IntoResponse {
    let measurement = Measurement::from(params);
    (StatusCode::OK, to_json!(measurement))
}
