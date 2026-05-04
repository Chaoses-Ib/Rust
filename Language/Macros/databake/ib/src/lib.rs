use ib_types::Config;

pub const CONFIG: Config = include!(concat!(env!("OUT_DIR"), "/config.rs"));
