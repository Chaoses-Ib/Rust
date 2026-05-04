use std::{env, fs};

use databake::Bake;
use ib_types::Config;

fn main() {
    println!("cargo:rerun-if-env-changed=CONFIG");

    let config: Config = env::var("CONFIG")
        .ok()
        .and_then(|json| serde_json::from_str(&json).ok())
        .unwrap_or_default();
    let baked = config.bake(&Default::default()).to_string();

    let out_dir = env::var("OUT_DIR").unwrap();
    fs::write(format!("{out_dir}/config.rs"), baked).unwrap();
}
