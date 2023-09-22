mod get_current;
mod get_stats;
mod insert_measurement;

use axum::{routing::get, Router};

use self::get_current::get_stats_current;
use self::get_stats::get_stats;
use self::insert_measurement::insert_measurement;

pub fn get_router() -> Router {
    return Router::new()
        .route("/", get(get_stats).post(insert_measurement))
        .route("/current", get(get_stats_current));
}
