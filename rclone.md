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

Problem: Seems the files have been uploaded to a collection, although the path in the buckets are not visible? 
> Question: Are the paths preserved somewhere within the bucket? Or is the bucket name only?

```
curl -s -X GET -H "Authorization: Bearer $API_KEY" https://api.estuary.tech/collections/content/$UUID | jq 

[
  {
    "id": 19561072,
    "updatedAt": "2022-02-24T03:42:04.966768Z",
    "cid": "bafybeifcjggf3bjnao34wabatshts7jn3r34w3m34dhdrl4wdyyngux27e",
    "name": "MyFoolishHeartV0.7.mp3",
    "userId": 157,
    "description": "",
    "size": 13206078,
    "active": true,
    "offloaded": false,
    "replication": 6,
    "aggregatedIn": 19567335,
    "aggregate": false,
    "pinning": false,
    "pinMeta": "",
    "failed": false,
    "location": "SHUTTLE1d45aa63-0927-451f-85d8-748d0a8e1c39HANDLE",
    "dagSplit": false,
    "splitFrom": 0
  },
  {
    "id": 19561076,
    "updatedAt": "2022-02-24T03:42:12.013792Z",
    "cid": "bafybeieq6tqlggvsgm2xp3nxr4yyqwep7jm4w3f4gogz7zqze6lc63kowq",
    "name": "TibcoLiveViewIotDemo.mp4",
    "userId": 157,
    "description": "",
    "size": 66933141,
    "active": true,
    "offloaded": false,
    "replication": 6,
    "aggregatedIn": 19567335,
    "aggregate": false,
    "pinning": false,
    "pinMeta": "",
    "failed": false,
    "location": "SHUTTLE1d45aa63-0927-451f-85d8-748d0a8e1c39HANDLE",
    "dagSplit": false,
    "splitFrom": 0
  },
  {
    "id": 19565117,
    "updatedAt": "2022-02-24T03:47:31.124465Z",
    "cid": "bafybeieq6tqlggvsgm2xp3nxr4yyqwep7jm4w3f4gogz7zqze6lc63kowq",
    "name": "TibcoLiveViewIotDemo.mp4",
    "userId": 157,
    "description": "",
    "size": 66933141,
    "active": true,
    "offloaded": false,
    "replication": 6,
    "aggregatedIn": 19567335,
    "aggregate": false,
    "pinning": false,
    "pinMeta": "",
    "failed": false,
    "location": "SHUTTLE1d45aa63-0927-451f-85d8-748d0a8e1c39HANDLE",
    "dagSplit": false,
    "splitFrom": 0
  },
```