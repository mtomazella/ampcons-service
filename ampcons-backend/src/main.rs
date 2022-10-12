mod data;
mod database;
mod routes;
mod utils;

use axum::{extract::Query, http::StatusCode, response::IntoResponse, routing::get, Router};
use serde::Deserialize;

use routes::measurement;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();
    let app = Router::new()
        .route("/ping", get(ping))
        .nest("/measurement", measurement::get_router());

    axum::Server::bind(&"192.168.15.7:3001".parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();

    tracing::info!("listening on 3001");
}

#[derive(Deserialize)]
struct PingQuery {
    message: Option<String>,
}
async fn ping(Query(params): Query<PingQuery>) -> impl IntoResponse {
    (
        StatusCode::OK,
        to_json!({ "connection": true, "message": params.message }),
    )
}
