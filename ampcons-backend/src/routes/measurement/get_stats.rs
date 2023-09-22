use std::{collections::HashMap, io::Repeat};

use axum::{extract::Query, http::StatusCode, response::IntoResponse};

use crate::to_json;

struct Request {
    sensor_ids: String,
}
#[derive(serde::Serialize)]
struct Response {
    sensor_ids: Vec<String>,
}

pub async fn get_stats(Query(params): Query<HashMap<String, String>>) -> impl IntoResponse {
    let sensor_ids: Vec<String> = params["sensor_ids"]
        .split_terminator(",")
        .map(|string: &str| string.to_string())
        .collect();

    let response = Response {
        sensor_ids: sensor_ids,
    };
    (StatusCode::OK, to_json!(response))
}
