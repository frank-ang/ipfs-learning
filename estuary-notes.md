# Estuary learning experiements

Set environment variable
```sh
export ESTUARY_TOKEN=REPLACE_ME_WITH_ESTUARY_TOKEN
```

Create a large 1GB file
```sh
DATA_FILE=random-1GB.txt
base64 /dev/urandom | head -c 1000000000 > $DATA_FILE
```

Add file
```sh
curl -X POST https://shuttle-5.estuary.tech/content/add -H \
"Authorization: Bearer $ESTUARY_TOKEN" -H "Accept: application/json" -H "Content-Type: multipart/form-data" \
-F "data=@$DATA_FILE"
```

List stats:
```sh
curl -X GET -H "Authorization: Bearer $ESTUARY_TOKEN" https://api.estuary.tech/content/stats | jq .
```

List deals:
```sh
curl -X GET -H "Authorization: Bearer $ESTUARY_TOKEN" https://api.estuary.tech/content/deals | jq .
```

Deals seem to appear after several days (!)
```sh
curl -X GET -H "Authorization: Bearer $ESTUARY_TOKEN" https://api.estuary.tech/content/status/12 | jq .
```


List pins:
```sh
curl -X GET https://api.estuary.tech/pinning/pins -H "Content-Type: application/json" -H "Authorization: Bearer $ESTUARY_TOKEN" | jq .
```

Get Pin by ID:
```sh
CID=REPLACE_ME
curl -X GET https://api.estuary.tech/pinning/pins/:$CID -H "Content-Type: application/json" -H "Authorization: Bearer $ESTUARY_TOKEN"
```

# 2022-02-09 estuary.tech experiment

Approach:
* Generate 3.73 GiB of random data, 4 files of 1GB size.
* Add the directory to IPFS. Pin it.
* Upload CID to https://estuary.tech


```sh
ipfs add -r random-data 
added QmZDk3a427bxU9vzutCzaeBgmP3iuzTf8ZF7PB7hqHLdVj random-data/random-1GB-a.txt
added QmZxzqtkFKcAnL11an8gWJ5qNwQ7EDAKH72179dRSGdbe8 random-data/random-1GB-b.txt
added QmToBcmdQfpCShu2gNY3WuinqRofy9qSiZCAuGkDYTQdas random-data/random-1GB-c.txt
added QmVkZm5EJa1VwqRrMfNGz2m5hm3gEzkhtA1GT2Av47ubXH random-data/random-1GB-d.txt
added QmWQ9sVMN8gSSyF6yPYQXtDNqyE5RmLbHnEzLJAuP2svXJ random-data
# note the CID
# Don't need to pin... Estuary will pin the content.
# ipfs pin -r <CID>
```

```
ipfs ls $CID
ipfs refs $CID
ipfs resolve $CID
```

Uploaded CID to estuary.tech at Thu Feb 10 02:58:54 UTC 2022

... After 2 hours, still waiting on website to reflect deal activity. Perhaps estuary periodically schedules this?


# 2022-02-09 Estuary build on EC2 experiment.

## Launch Linux instance. 

I use Ubuntu 20 AMI on r5a.xlarge spot instance, Root EBS gp3 8GB, Additional EBS gp3 30GB.

Make 2nd EBS volume available to Linux:
```sh

# make xfs partition
lsblk
sudo lsblk -f
sudo file -s /dev/nvme1n1
sudo mkfs -t xfs /dev/nvme1n1
sudo file -s /dev/nvme1n1
# get the uuid
sudo blkid
# append the /etc/fstab like:
UUID=<UUID> /data xfs defaults 0 0

# mount
sudo mkdir /data
sudo mount -a

# verify
sudo touch /data/foo
ls /data
sudo umount /data
ls /data
sudo mount -a
ls /data

# prep data directory
sudo mkdir /data/estuary
sudo chown ubuntu:ubuntu /data/estuary
```

## install prereqs
```sh
# go (1.15 or higher)
sudo snap install go --classic

# jq
sudo snap install jq

# hwloc
sudo apt update
sudo apt install -y hwloc

# opencl
## ... skip for EC2 without acceleration?

# other dependencies
sudo apt install -y make
sudo apt install -y pkg-config
sudo apt install -y gcc
sudo apt install -y libhwloc-dev
sudo apt install -y ocl-icd-opencl-dev

```

## Build and Run Estuary

```sh
# build
make clean all
./estuary setup
export FULLNODE_API_INFO=wss://api.chain.love

# Increase UDP receive buffer size
sysctl -w net.core.rmem_max=2500000

# Increase file limit, avoids "netlinkrib: too many open files" error.
ulimit -n 10000

# Start Estuary
./estuary --datadir=/data/estuary --logging

```
> Runs on port: 3004

## Initialize & Start a Shuttle

```sh
# Init shuttle
export ESTUARY_TOKEN=`cat ../estuaryAuthToken.txt`
curl -H "Authorization: Bearer $ESTUARY_TOKEN" -X POST localhost:3004/admin/shuttle/init
# Note down the output, set environment variables

# Increase file limit
ulimit -n 10000

# Start shuttle
./estuary-shuttle --dev --estuary-api=localhost:3004 --auth-token=$SHUTTLE_TOKEN --handle=$SHUTTLE_HANDLE

```
> Runs on port: 3005


## Estuary WWW

Install Node

```sh
sudo apt install -y nodejs
sudo apt install -y npm

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm list-remote
nvm install v16.14.0
nvm install v14.19.0
nvm alias default v14.19.0
node --version
```

Estuary WWW
```sh
npm install
npm run dev
```
> Runs on port 4444

> Signin using token: { error: 'ERR_INVALID_TOKEN' }

> Signin succeeds using estuary.tech token. Seems to be pointing to central endpoints https://shuttle-4.estuary.tech/

## Use the API

```sh
export EST_HOST=http://localhost:3004
export ESTUARY_TOKEN=`cat ../estuaryAuthToken.txt`

# Public API
curl -X GET $EST_HOST/public/miners
curl -X GET $EST_HOST/public/metrics/deals-on-chain
curl -X GET $EST_HOST/public/miners/storage/query/$MINER
curl -X GET $EST_HOST/public/miners/stats/$MINER
curl -X GET $EST_HOST/public/miners/failures/$MINER
curl -X GET $EST_HOST/public/miners/deals/$MINER


# Content
curl -X GET -H "Authorization: Bearer $ESTUARY_TOKEN" $EST_HOST/content/list
curl -X GET -H "Authorization: Bearer $ESTUARY_TOKEN" $EST_HOST/content/stats
curl -X GET -H "Authorization: Bearer $ESTUARY_TOKEN" $EST_HOST/pinning/pins 

curl -X GET -H "Authorization: Bearer $ESTUARY_TOKEN" $EST_HOST/viewer

export CID=`curl -sX GET -H "Authorization: Bearer $ESTUARY_TOKEN" $EST_HOST/content/list | jq -r '.[0].cid'`
curl -X GET -H "Authorization: Bearer $ESTUARY_TOKEN" $EST_HOST/content/by-cid/$CID

curl -X GET -H "Authorization: Bearer $ESTUARY_TOKEN" $EST_HOST/content/deals

```

Generate data.

```sh
DATA_FILE=/data/tmp/random.txt
base64 /dev/urandom | head -c 5000000000 > $DATA_FILE
```

Add data.

```sh

curl  -X POST -H "Authorization: Bearer $ESTUARY_TOKEN" \
 -H "Accept: application/json" \
 -H "Content-Type: multipart/form-data" \
 -F "data=@$DATA_FILE;type=text/plain" \
 $EST_HOST/content/add 
```


## Errors


2022-02-10T13:16:42.608Z        INFO    estuary estuary/replication.go:2329     deal failure error      {"miner": "f071624", "phase": "propose", "msg": "unrecognized response state 11: deal rejected: node error getting client market balance failed: resolve address f1vmby5xim3urt6v3pudtsjknfwzyb2do5qonrvii: actor not found", "content": 1}


# Estuary on local MacOS:

Setup.

```
./estuary setup
adding default miner list to database...
Auth Token: EST7da12584-1542-463b-8254-e404da3e4e45ARY
```

Run.

```
export FULLNODE_API_INFO=wss://api.chain.love
./estuary --datadir=/tmp/estuary --logging

# Run on Devnet
./estuary --datadir=/tmp/estuary --repo=~/.lotusDevnet --logging


Wallet address is:  f15rk2buq4fniqcy32x5tvnylrdvyzvbojw5diani
...
⇨ http server started on [::]:3004
```

> Runs on port: 3004

Test

```
export EST_HOST=http://localhost:3004
curl -X GET $EST_HOST/public/miners
curl -X GET -H "Authorization: Bearer $ESTUARY_TOKEN" $EST_HOST/content/staging-zones

```

Init Shuttle

```
export FULLNODE_API_INFO=wss://api.chain.love
curl -H "Authorization: Bearer $ESTUARY_TOKEN" -X POST $EST_HOST/admin/shuttle/init

{"handle":"SHUTTLEc8b46e7e-3c26-41cf-be63-003cf7261975HANDLE","token":"SECRET92da2c32-c6e5-4867-80ee-159e312c9433SECRET"}

{"handle":"SHUTTLE5b2b280b-0d7b-4ef6-9307-8a4c5d45f6ccHANDLE","token":"SECRET83211817-8c4f-4013-bf51-1eb4bb1ebd53SECRET"}

```

Start Shuttle

```
./estuary-shuttle --dev --estuary-api=localhost:3004 --auth-token=$SHUTTLE1_TOKEN --handle=$SHUTTLE1_HANDLE

⇨ http server started on [::]:3005
```

> Runs on port: 3005

add a dummy file.
```
./add-file.sh                          
+ curl --progress-bar -X POST -H 'Authorization: Bearer EST7784af1e-e4bb-4e57-a96c-a76c2a32c513ARY' -F data=@files/dummy.file -F name=dummy.file 'http://localhost:3004/content/add?collection='
{"cid":"bafkqaflunbuxgidjomqgcideovww26jamzuwyzik","estuaryId":1,"providers":["/ip4/192.168.1.167/tcp/6744/p2p/12D3KooWD6AUkW2GduxnxLjLxAv5kZUMuvEtPXbzv7pxBx5VEcJE","/ip4/127.0.0.1/tcp/6744/p2p/12D3KooWD6AUkW2GduxnxLjLxAv5kZUMuvEtPXbzv7pxBx5VEcJE","/ip4/172.22.16.78/tcp/24347/p2p/12D3KooWD6AUkW2GduxnxLjLxAv5kZUMuvEtPXbzv7pxBx5VEcJE","/ip4/103.6.151.82/tcp/24347/p2p/12D3KooWD6AUkW2GduxnxLjLxAv5kZUMuvEtPXbzv7pxBx5VEcJE"]}
```

add another test file
```
curl  -X POST -H "Authorization: Bearer $ESTUARY_TOKEN" \
 -H "Accept: application/json" \
 -H "Content-Type: multipart/form-data" \
 -F "data=@$DATA_FILE;type=text/plain" \
 $EST_HOST/content/add
{"cid":"bafkreicsc76eag6svbliy7dwye2b7nw3eptth4pwgskkbna6bxef76bpbi","estuaryId":3,"providers":["/ip4/192.168.1.167/tcp/6744/p2p/12D3KooWD6AUkW2GduxnxLjLxAv5kZUMuvEtPXbzv7pxBx5VEcJE","/ip4/127.0.0.1/tcp/6744/p2p/12D3KooWD6AUkW2GduxnxLjLxAv5kZUMuvEtPXbzv7pxBx5VEcJE","/ip4/172.22.16.78/tcp/24347/p2p/12D3KooWD6AUkW2GduxnxLjLxAv5kZUMuvEtPXbzv7pxBx5VEcJE","/ip4/103.6.151.82/tcp/24347/p2p/12D3KooWD6AUkW2GduxnxLjLxAv5kZUMuvEtPXbzv7pxBx5VEcJE"]}
```


## Estuary WWW on local Mac.

```
npm install
ESTUARY_API=http://localhost:3004 npm run dev
```

> Runs on http://localhost:4444

Login using API Key.

## Estuary Admin:

### Balance TODO

> Add FIL or DataCap.

> Add to Estuary Escrow


### Storage Providers

> Setup a miner.

Get signature

To get started with adding a provider/miner, please enter your provider/miner ID to obtain a hex message and a command to run on Lotus.

MinerID: f01000
```
lotus wallet sign YOUR_WORKER_ADDRESS 2d2d2d2d20757365722031206f776e73206d696e657220663031303030202d2d2d2d
```

Claim your miner
Use the signature provided to claim your miners.
...


## Restart Estuary against local devnet

export FULLNODE_API_INFO=ws://localhost:1234 
./estuary --datadir=/tmp/estuary --logging

> ERROR

Click "Balance" shows Actor Not Found

```
# Estuary
{"time":"2022-03-11T17:40:34.042569+08:00","id":"","remote_ip":"::1","host":"localhost:3004","method":"GET","uri":"/admin/balance","user_agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36","status":500,"error":"resolution lookup failed (t1iijcqzkckbxb6pvwbxcmyncnqcrlym6iivaisui): resolve address t1iijcqzkckbxb6pvwbxcmyncnqcrlym6iivaisui: actor not found","latency":693084,"latency_human":"693.084µs","bytes_in":0,"bytes_out":157}

# Lotus
2022-03-11T17:40:34.042+0800	WARN	rpc	go-jsonrpc@v0.1.5/handler.go:279	error in RPC call to 'Filecoin.StateGetActor': resolution lookup failed (t1iijcqzkckbxb6pvwbxcmyncnqcrlym6iivaisui):
    github.com/filecoin-project/lotus/chain/state.(*StateTree).GetActor
        /Users/frankang/lab/lotus/chain/state/statetree.go:362
  - resolve address t1iijcqzkckbxb6pvwbxcmyncnqcrlym6iivaisui:
    github.com/filecoin-project/lotus/chain/state.(*StateTree).lookupIDinternal
        /Users/frankang/lab/lotus/chain/state/statetree.go:327
  - actor not found


```

### Add FIL to estuary

> Seems important for wallet operations: unset FULLNODE_API_INFO
```
unset FULLNODE_API_INFO
lotus wallet list
```

Get the estuary wallet address in the estuary console.
```
Wallet address is:  <ADDRESS_HERE>
```

Transfer FIL from node wallet to estuary wallet.
```
lotus wallet list

Address                                                                                 Balance                          Nonce  Default  
t3r32thhhdzb5rhvkxqbobirkdcqpyuakibrcykr7px4sotexpo5ey3lzawmp7orhyk4ekht5syxc77nmn6rqa  49999999.999913475777038534 FIL  5      X 

lotus send --from t3r32thhhdzb5rhvkxqbobirkdcqpyuakibrcykr7px4sotexpo5ey3lzawmp7orhyk4ekht5syxc77nmn6rqa f1btnpfivspuy5ekksku7gkgdnteydmda6kv33oba 1

# and so on...
```

> Confirm on estuary-www of balance FIL in Estuary wallet ...

### Transfer FIL to Estuary Escrow:

Click transfer feature on estuary-www page. 

> TODO: Troubleshoot:

NODE ERROR:
```
2022-03-14T16:39:08.496+0800	WARN	rpc	go-jsonrpc@v0.1.5/handler.go:279	error in RPC call to 'Filecoin.MpoolPush': missing permission to invoke 'MpoolPush' (need 'write'):
    github.com/filecoin-project/go-jsonrpc/auth.PermissionedProxy.func1
        /Users/frankang/go/pkg/mod/github.com/filecoin-project/go-jsonrpc@v0.1.5/auth/auth.go:65
```

Estuary ERROR:
```
{"time":"2022-03-14T16:37:10.181493+08:00","id":"","remote_ip":"::1","host":"localhost:3004","method":"OPTIONS","uri":"/admin/add-escrow/1","user_agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36","status":204,"error":"","latency":13500,"latency_human":"13.5µs","bytes_in":0,"bytes_out":0}
2022-03-14T16:37:10.188+0800	ERROR	estuary	estuary/handlers.go:96	handler error: missing permission to invoke 'MpoolPush' (need 'write')
{"time":"2022-03-14T16:37:10.188074+08:00","id":"","remote_ip":"::1","host":"localhost:3004","method":"POST","uri":"/admin/add-escrow/1","user_agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36","status":500,"error":"missing permission to invoke 'MpoolPush' (need 'write')","latency":5213167,"latency_human":"5.213167ms","bytes_in":2,"bytes_out":68}
```

### Things to try... .

> IMPORTANT: CLI requires ```unset FULLNODE_API_INFO```

To avoid the error:
```
API Token not set and requested, capabilities might be limited.
ERROR: missing permission to invoke 'AuthNew' (need 'admin')
```

Create a write token (illustration)
```
unset FULLNODE_API_INFO

lotus auth create-token --perm write
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiXX0.X-S093DHDPywB4OuRX4wwIwbxtVFx_1m5NLzUNNqkTs

lotus auth create-token --perm admin
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.1NmwdhS8nfgpbJuvgWMk7ZnsP6sVcMRe5x1RDRee3eY
```

### How to authorize Estuary for Lotus write API calls?

> Which token is Estuary using??
> Capture packet trace?
```
networksetup -listallhardwareports

sudo tcpdump -i lo0 -v
sudo tcpdump -i lo0 -v 'tcp port 1234'
sudo tcpdump -i lo0 -v -w /tmp/loopback.pcap 'tcp port 1234'
sudo tcpdump -i lo0 -s 0 -B 524288 -v -w /tmp/loopback.pcap 'tcp port 1234'

```

> Wireshark trace shows the Auth header is missing. Estuary is not sending Auth.

```
POST /rpc/v1 HTTP/1.1
Host: localhost:1234
User-Agent: Go-http-client/1.1
Content-Length: 656
Content-Type: application/json
Accept-Encoding: gzip

{"jsonrpc":"2.0","id":17,"method":"Filecoin.MpoolPush","params":[{"Message":{"Version":0,"To":"f05","From":"f1btnpfivspuy5ekksku7gkgdnteydmda6kv33oba","Nonce":0,"Value":"1000000000000000000","GasLimit":1332693,"GasFeeCap":"4000000000","GasPremium":"200346","Method":2,"Params":"VQEM2vKisn0x0ilSVT5lGG2ZMDYMHg==","CID":{"/":"bafy2bzaceanaw2alvv3e2fylyipujnfvpzllgmuh35awrjce66bxky2hfhc7a"}},"Signature":{"Type":1,"Data":"kPysHsv+pFv33LnDUbUeqWuH0MshRDMqIwVPu556uAVKIq6DEfkzCir3gaLZiaaiDhLZVfIryy0WJdRkhC1LnQE="},"CID":{"/":"bafy2bzacea6w7c4jdmawp7lq43fptmpvm2qfti7747pjayzccs6dmfmzehxem"}}],"meta":{"SpanContext":"AAD7d7TedRAPrt0PCqH3ednZAa4FUZ9AAmE+AgA="}}

HTTP/1.1 200 OK
Date: Tue, 22 Mar 2022 08:28:06 GMT
Content-Length: 113
Content-Type: text/plain; charset=utf-8

{"jsonrpc":"2.0","id":17,"error":{"code":1,"message":"missing permission to invoke 'MpoolPush' (need 'write')"}}
```

> Try manually posting the MPoolPush message using curl.

```
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(cat ~/.lotusDevnet/token)" \
  --data '{"jsonrpc":"2.0","id":17,"method":"Filecoin.MpoolPush","params":[{"Message":{"Version":0,"To":"f05","From":"f1btnpfivspuy5ekksku7gkgdnteydmda6kv33oba","Nonce":0,"Value":"1000000000000000000","GasLimit":1332693,"GasFeeCap":"4000000000","GasPremium":"200346","Method":2,"Params":"VQEM2vKisn0x0ilSVT5lGG2ZMDYMHg==","CID":{"/":"bafy2bzaceanaw2alvv3e2fylyipujnfvpzllgmuh35awrjce66bxky2hfhc7a"}},"Signature":{"Type":1,"Data":"kPysHsv+pFv33LnDUbUeqWuH0MshRDMqIwVPu556uAVKIq6DEfkzCir3gaLZiaaiDhLZVfIryy0WJdRkhC1LnQE="},"CID":{"/":"bafy2bzacea6w7c4jdmawp7lq43fptmpvm2qfti7747pjayzccs6dmfmzehxem"}}],"meta":{"SpanContext":"AAD7d7TedRAPrt0PCqH3ednZAa4FUZ9AAmE+AgA="}}' 'http://localhost:1234/rpc/v0'
```

Result, successful. But not sure if any follow-up API calls are required to complete the Escrow...?
```
{"jsonrpc":"2.0","result":{"/":"bafy2bzacea6w7c4jdmawp7lq43fptmpvm2qfti7747pjayzccs6dmfmzehxem"},"id":17}
```



### Add the devnet miner.

TODO...

### Init and Launch Estuary shuttle