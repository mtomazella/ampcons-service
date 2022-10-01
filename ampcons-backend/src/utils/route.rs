use axum::{http::StatusCode, Json};
use influxdb_rs::{error::ErrorKind, Error};
use serde_json::Value;

use crate::to_json;

pub fn get_response_for_influxdb_error(err: Error) -> (StatusCode, Json<Value>) {
    let create_response = |code: StatusCode| (code, to_json!({}));

    let error_type = err.inner;

    match error_type {
        ErrorKind::InvalidCredentials(_) => create_response(StatusCode::UNAUTHORIZED),
        ErrorKind::Communication(_) => create_response(StatusCode::BAD_GATEWAY),
        ErrorKind::SyntaxError(_) => create_response(StatusCode::UNPROCESSABLE_ENTITY),
        _ => create_response(StatusCode::INTERNAL_SERVER_ERROR),
    }
}
