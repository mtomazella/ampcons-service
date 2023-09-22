use std::{collections::HashMap, io::Repeat};

use axum::{extract::Query, http::StatusCode, response::IntoResponse};

use crate::{data::measurements::Measurement, to_json};

struct Request {
    sensor_id: String,
}

pub async fn get_stats_current(Query(params): Query<HashMap<String, String>>) -> impl IntoResponse {
    let sensor_ids: String = params["sensor_id"];

    (StatusCode::OK, to_json!(response))
}
