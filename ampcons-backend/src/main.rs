mod data;
mod database;
mod routes;
mod utils;

use axum::{extract::Query, http::StatusCode, response::IntoResponse, routing::get, Router};
use serde::Deserialize;
use std::net::SocketAddr;

use routes::measurement;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();
    let app = Router::new()
        .route("/ping", get(ping))
        .nest("/measurement", measurement::get_router());

    let addr = SocketAddr::from(([127, 0, 0, 1], 3001));
    tracing::info!("listening on {}", addr);
    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
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
