use axum::{http::StatusCode, Json};
use influxdb::Error;
use serde_json::Value;

use crate::to_json;

pub fn get_response_for_influxdb_error(err: Error) -> (StatusCode, Json<Value>) {
    let create_response = |code: StatusCode| (code, to_json!({ "error": err.to_string() }));

    match err {
        Error::AuthenticationError => create_response(StatusCode::UNAUTHORIZED),
        Error::AuthorizationError => create_response(StatusCode::FORBIDDEN),
        Error::ConnectionError { error: _ } => create_response(StatusCode::BAD_GATEWAY),
        Error::InvalidQueryError { error: _ } => create_response(StatusCode::UNPROCESSABLE_ENTITY),
        _ => create_response(StatusCode::INTERNAL_SERVER_ERROR),
    }
}
