set quiet := true

mod bootstrap
mod kubernetes
mod talos

[private]
default:
    just -l clusters k4
