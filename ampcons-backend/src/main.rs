mod utils;

use rocket::response::status::Custom;
use utils::responses::success_response;

#[macro_use]
extern crate rocket;

#[get("/ping")]
fn index() -> Custom<String> {
    success_response()
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![index])
}
