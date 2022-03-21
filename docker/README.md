# Docker

Build.
```
docker build . -t lotus-test -f Dockerfile.lotus 
```

Error: with rustup
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


