#[cfg(feature = "build")]
use databake::Bake;
#[cfg(feature = "build")]
use serde::{Deserialize, Serialize};

#[cfg_attr(feature = "build",
    derive(Serialize, Deserialize, Bake, Default),
    databake(path = ib_types),
)]
pub struct Config {}
