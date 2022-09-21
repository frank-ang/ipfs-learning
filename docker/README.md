# Docker

To build Lotus on Mac Apple Silicon successfully, you need to set the _DOCKER_DEFAULT_PLATFORM_ as _linux/amd64_.

```
export DOCKER_DEFAULT_PLATFORM=linux/amd64
docker build . -t lotus-test -f Dockerfile.lotus 
```


Another way to build, rename the Dockerfile
```
mv Dockerfile.lotus Dockerfile
docker build -t lotus .
```

Otherwise this build-time error results:
```
#8 2.897 qemu-x86_64: Could not open '/lib64/ld-linux-x86-64.so.2': No such file or directory
#8 2.903 chmod: cannot access '/usr/local/rustup': No such file or directory
#8 2.903 chmod: cannot access '/usr/local/cargo': No such file or directory
#8 2.904 /bin/sh: 1: rustup: not found
#8 2.904 /bin/sh: 1: cargo: not found
#8 2.904 /bin/sh: 1: rustc: not found
------
executor failed running [/bin/sh -c wget "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init";     chmod +x rustup-init;     ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION;     rm rustup-init;     chmod -R a+w $RUSTUP_HOME $CARGO_HOME;     rustup --version;     cargo --version;     rustc --version;]: exit code: 127
```


