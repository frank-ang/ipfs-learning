# Estuary Collections

## Collections
Get collections.
```
curl -s -X GET -H "Authorization: Bearer $API_KEY" https://api.estuary.tech/collections/list | jq '.[] | {name, uuid}'
{
  "name": "frankang-rclone-test",
  "uuid": "70f75cb9-9047-48b2-948b-7f7734dffd05"
}
{
  "name": "frankang-rclone",
  "uuid": "853a950c-a91d-45aa-ae09-ccc310c8efc9"
}
```

> Question: what "filesystem delimiter" does/can collections use? "/" ?

List collections content

```
curl -s -X GET -H "Authorization: Bearer $API_KEY" https://api.estuary.tech/collections/content/$UUID | jq '.[] | {id,cid,name}'

```

> Question / note: Rclone doesn't seem to preserve S3 origin paths.
```
# No matches at a known path at origin "/media"
curl -s -X GET -H "Authorization: Bearer $API_KEY" 'https://api.estuary.tech/collections/fs/list?col=853a950c-a91d-45aa-ae09-ccc310c8efc9&dir=/media'
null


```

## FS add content API?

```
# Create a collection.
curl -X POST https://api.estuary.tech/collections/create -d '{ "name": "collection00", "description": "Test collection 00" }' -H "Content-Type: application/json" -H "Authorization: Bearer $API_KEY"

{"createdAt":"2022-03-02T09:13:09.365903491Z","uuid":"59f2e9a1-6de7-4c25-ab75-05877022e1c2",
"name":"collection00","description":"Test collection 00","userId":157}


# Content Add, vanilla is ok

curl -X POST 'https://shuttle-4.estuary.tech/content/add' -H "Authorization: Bearer $API_KEY" -H "Accept: application/json" -H "Content-Type: multipart/form-data" -F "data=@/tmp/data/hello.txt"
{"cid":"bafkreihjinvbgchirpovxuc7w6e3fvyhr5k7geej55t7f4vzhhcs63cuxa","estuaryId":20829565,"providers":["/ip4/3.134.223.177/tcp/6745/p2p/12D3KooWN8vAoGd6eurUSidcpLYguQiGZwt4eVgDvbgaS7kiGTup"]}

# Content Add to collection path. Error, wrong param names. Bug in docs??
Whats the correct parameter names?
https://docs.estuary.tech/api-content-add

curl -X POST 'https://shuttle-4.estuary.tech/content/add?collection=$UUID&collectionPath=/dir0/dir00/hello.txt' -H "Authorization: Bearer $API_KEY" -H "Accept: application/json" -H "Content-Type: multipart/form-data" -F "data=@/tmp/data/hello.txt"
{"error":"create content request failed, got back content ID zero"}

# Content Add to collection path. Added BUT cannot list it at path?
curl -X POST 'https://shuttle-4.estuary.tech/content/add?col=$UUID&dir=/dir0/dir00/hello.txt' -H "Authorization: Bearer $API_KEY" -H "Accept: application/json" -H "Content-Type: multipart/form-data" -F "data=@/tmp/data/hello.txt"
{"cid":"bafkreihjinvbgchirpovxuc7w6e3fvyhr5k7geej55t7f4vzhhcs63cuxa","estuaryId":20829741,"providers":["/ip4/3.134.223.177/tcp/6745/p2p/12D3KooWN8vAoGd6eurUSidcpLYguQiGZwt4eVgDvbgaS7kiGTup"]}
```

# FS List contents at "child" path .. not found??
```
curl -X GET -H "Authorization: Bearer $API_KEY" 'https://api.estuary.tech/collections/fs/list?col=$UUID&dir=/dir0/dir00'
{"error":"record not found"}

curl -X GET -H "Authorization: Bearer $API_KEY" https://api.estuary.tech/content/stats | jq | grep -C 5 bafkreihjinvbgchirpovxuc7w6e3fvyhr5k7geej55t7f4vzhhcs63cuxa


```

# Add content to path
```
curl -X POST 'https://api.estuary.tech/collections/fs/add?col=$UUID&content=bafkreihjinvbgchirpovxuc7w6e3fvyhr5k7geej55t7f4vzhhcs63cuxa&path=/dir0/hello.txt' -H "Content-Type: application/json" -H "Authorization: Bearer $API_KEY"

{"error":"record not found"}

curl -X POST 'https://api.estuary.tech/collections/fs/add?col=$UUID&content=020829741&path=/dir0/hello.txt' -H "Content-Type: application/json" -H "Authorization: Bearer $API_KEY"

{"error":"record not found"}

```



## Seems broken??
```
curl -X POST https://api.estuary.tech/content/add-ipfs -d '{ "name": "hello.txt", "root": "bafkreihjinvbgchirpovxuc7w6e3fvyhr5k7geej55t7f4vzhhcs63cuxa", "collection": "$UUID", "collectionPath": "/dir1/hello.txt" }' -H "Content-Type: application/json" -H "Authorization: Bearer $API_KEY"


curl -X POST https://api.estuary.tech/content/add-ipfs -d '{ "name": "file1.txt", "root": "QmS8dypUY34t3UF7Xd98KhuxqQ8F45WckJCGkdhNnwgvM4", "collection": "28d923b5-2561-43ee-8ab3-fb42088666f2", "collectionPath": "/dir1/file1.txt" }' -H "Content-Type: application/json" -H "Authorization: Bearer REPLACE_ME_WITH_API_KEY"



{"error":"record not found"}

curl -X POST https://api.estuary.tech/content/add-ipfs -d '{ "name": "hello.txt", "root": "020829741", "collection": "$UUID", "collectionPath": "/dir1/hello.txt" }' -H "Content-Type: application/json" -H "Authorization: Bearer $API_KEY"

```

--- 

# CAR approach?

https://github.com/web3-storage/ipfs-car
https://www.npmjs.com/package/ipfs-car

Install ipfs-car
```
npm install -g ipfs-car
```

## Pack and unpack CAR file.

```
npx ipfs-car --help

# write a content addressed archive to the current working dir.
npx ipfs-car --pack root/
# outputs the CID. (mac)
root CID: bafybeib5zk2iruyvlh6365wqvjymcodqmoygnqcqaqt7nahu26n3tfszou
  output: root.car
npx ipfs-car --unpack root.car 
# unpacks to local directory named $CID
```

## Add CAR to Estuary

Succeeds against shuttle.

```
# Failed endpoint
curl -X POST https://api.estuary.tech/content/add-car -H "Authorization: Bearer $API_KEY" -H "Accept: application/json" -T ./root.car
{"error":"ERR_CONTENT_ADDING_DISABLED"}

# Add small CAR: Hello files
curl -X POST https://shuttle-4.estuary.tech/content/add-car -H "Authorization: Bearer $API_KEY" -H "Accept: application/json" -T ./root.car
{"cid":"bafybeib5zk2iruyvlh6365wqvjymcodqmoygnqcqaqt7nahu26n3tfszou","estuaryId":20847962,"providers":["/ip4/3.134.223.177/tcp/6745/p2p/12D3KooWN8vAoGd6eurUSidcpLYguQiGZwt4eVgDvbgaS7kiGTup"]}

# Add larger CAR: Videos (456M)... trying to trigger from staging into a deal
curl -X POST https://shuttle-4.estuary.tech/content/add-car -H "Authorization: Bearer $API_KEY" -H "Accept: application/json" -T /tmp/data/stock-videos.car
{"cid":"bafybeic3mto3rid7iymk4iwcssiscv6dngqiun3dk5yyalgfaytqmu2bjy","estuaryId":20973762,"providers":["/ip4/3.134.223.177/tcp/6745/p2p/12D3KooWN8vAoGd6eurUSidcpLYguQiGZwt4eVgDvbgaS7kiGTup"]}

```


## Notes

> Graphsplit
A tool for splitting a large dataset into graph slices to make deals in the Filecoin Network
https://github.com/filedrive-team/go-graphsplit

