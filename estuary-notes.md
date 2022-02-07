# Estuary learning experiements

Set environment variable
```sh
export API_KEY=REPLACE_ME_WITH_API_KEY
```

Create a large 1GB file
```sh
DATA_FILE=random-1GB.txt
base64 /dev/urandom | head -c 1000000000 > $DATA_FILE
```

Add file
```sh
curl -X POST https://shuttle-5.estuary.tech/content/add -H \
"Authorization: Bearer $API_KEY" -H "Accept: application/json" -H "Content-Type: multipart/form-data" \
-F "data=@$DATA_FILE"
```

List stats:
```sh
curl -X GET -H "Authorization: Bearer $API_KEY" https://api.estuary.tech/content/stats | jq .
```

List deals:
```sh
curl -X GET -H "Authorization: Bearer $API_KEY" https://api.estuary.tech/content/deals | jq .
```

Deals seem to appear after several days (!)
```sh
curl -X GET -H "Authorization: Bearer $API_KEY" https://api.estuary.tech/content/status/12 | jq .
```


List pins:
```sh
curl -X GET https://api.estuary.tech/pinning/pins -H "Content-Type: application/json" -H "Authorization: Bearer $API_KEY" | jq .
```

Get Pin by ID:
```sh
CID=REPLACE_ME
curl -X GET https://api.estuary.tech/pinning/pins/:$CID -H "Content-Type: application/json" -H "Authorization: Bearer $API_KEY"
```

