#[flutter_rust_bridge::frb(init)]
pub fn init() {
    flutter_rust_bridge::setup_default_user_utils();
}
