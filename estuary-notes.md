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
export AUTH_TOKEN=`cat ../estuaryAuthToken.txt`
curl -H "Authorization: Bearer $AUTH_TOKEN" -X POST localhost:3004/admin/shuttle/init
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
export HOST=http://localhost:3004
export API_KEY=`cat ../estuaryAuthToken.txt`

# Public API
curl -X GET $HOST/public/miners
curl -X GET $HOST/public/metrics/deals-on-chain
curl -X GET $HOST/public/miners/storage/query/$MINER
curl -X GET $HOST/public/miners/stats/$MINER
curl -X GET $HOST/public/miners/failures/$MINER
curl -X GET $HOST/public/miners/deals/$MINER


# Content
curl -X GET -H "Authorization: Bearer $API_KEY" $HOST/content/list
curl -X GET -H "Authorization: Bearer $API_KEY" $HOST/content/stats
curl -X GET -H "Authorization: Bearer $API_KEY" $HOST/pinning/pins 

curl -X GET -H "Authorization: Bearer $API_KEY" $HOST/viewer

export CID=`curl -sX GET -H "Authorization: Bearer $API_KEY" $HOST/content/list | jq -r '.[0].cid'`
curl -X GET -H "Authorization: Bearer $API_KEY" $HOST/content/by-cid/$CID

curl -X GET -H "Authorization: Bearer $API_KEY" $HOST/content/deals

```

Generate data.

```sh
DATA_FILE=/data/tmp/random.txt
base64 /dev/urandom | head -c 5000000000 > $DATA_FILE
```

Add data.

```sh

curl  -X POST $HOST/content/add -H "Authorization: Bearer $API_KEY" \
 -H "Accept: application/json" \
 -H "Content-Type: multipart/form-data" \
 -F "text=@$DATA_FILE;type=text/plain"
```


## Errors


2022-02-10T13:16:42.608Z        INFO    estuary estuary/replication.go:2329     deal failure error      {"miner": "f071624", "phase": "propose", "msg": "unrecognized response state 11: deal rejected: node error getting client market balance failed: resolve address f1vmby5xim3urt6v3pudtsjknfwzyb2do5qonrvii: actor not found", "content": 1}
