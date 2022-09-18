use rocket::{http::Status, response::status::Custom};

pub(crate) fn success_response<B>(body: B) -> Custom<B> {
    Custom(Status::new(200), body)
}
