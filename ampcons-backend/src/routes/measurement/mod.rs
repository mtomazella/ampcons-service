mod handlers;

use axum::{routing::post, Router};

use self::handlers::insert_measurement;

pub fn get_router() -> Router {
    return Router::new().route("/", post(insert_measurement));
}
