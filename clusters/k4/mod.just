set quiet := true

mod bootstrap
mod talos

[private]
default:
    just -l cluster k4 talos