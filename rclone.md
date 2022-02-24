# Rclone 

https://github.com/application-research/rclone

https://rclone.org/install/

## Build on Mac

```
export LIBRARY_PATH=/opt/homebrew/lib 
export FFI_BUILD_FROM_SOURCE=1
go build
./rclone version
```

## Configure

Configure "aws" AWS S3 and "estuary" Estuary.
```
./rclone config
```

Config file created in ```~/.config/rclone/rclone.conf```


Copy data.

```
# copy successful to Estuary!
./rclone copy aws:frankang-rclone estuary:frankang-rclone

# Failed to check with 3 errors: last error was: 3 differences found
./rclone check aws:frankang-rclone estuary:frankang-rclone

# Running sync twice will create duplicates. (bug?)
./rclone sync aws:frankang-rclone estuary:frankang-rclone

```