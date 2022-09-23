#[macro_export]
macro_rules! to_json {
    ( $( $x:tt ),* ) => {{
        use axum::Json;
        use serde_json::json;
        $(Json(json!($x)))+
    }};
}
