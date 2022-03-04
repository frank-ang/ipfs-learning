# Lotus Miner Notes.

https://docs.filecoin.io/build/local-devnet/#manual-set-up
vs
https://lotus.filecoin.io/docs/developers/local-network/

# Devnet on Mac.

## Node terminal session.
```
export LOTUS_PATH=~/.lotusDevnet
export LOTUS_MINER_PATH=~/.lotusminerDevnet
export CGO_CFLAGS_ALLOW="-D__BLST_PORTABLE__"
export CGO_CFLAGS="-D__BLST_PORTABLE__"

# Build on Mac
git checkout v1.14.3
export LIBRARY_PATH=/opt/homebrew/lib
export FFI_BUILD_FROM_SOURCE=1
make clean
make 2k

# configuration
export LOTUS_SKIP_GENESIS_CHECK=_yes_
./lotus fetch-params 2048
./lotus-seed pre-seal --sector-size 2KiB --num-sectors 2
./lotus-seed genesis new localnet.json
./lotus-seed genesis add-miner localnet.json ~/.genesis-sectors/pre-seal-t01000.json


 % ./lotus-seed genesis add-miner localnet.json ~/.genesis-sectors/pre-seal-t01000.json

2022-03-01T13:32:51.868+0800	INFO	lotus-seed	lotus-seed/genesis.go:129	Adding miner t01000 to genesis template
2022-03-01T13:32:51.868+0800	INFO	lotus-seed	lotus-seed/genesis.go:146	Giving t3qcyd47d3tyzuoz7fws5tiwbkvebkzvn7q33zolbvsmhhw52ui4gvr6gwwqawm2f2jnq4hgplvewbda6b4amq some initial balance



# start the first node.
./lotus daemon --lotus-make-genesis=devgen.car --genesis-template=localnet.json --bootstrap=false

```

## Miner (Storage Provider) session.
```
export LOTUS_PATH=~/.lotusDevnet
export LOTUS_MINER_PATH=~/.lotusminerDevnet
./lotus wallet import --as-default ~/.genesis-sectors/pre-seal-t01000.key

>> imported key t3qcyd47d3tyzuoz7fws5tiwbkvebkzvn7q33zolbvsmhhw52ui4gvr6gwwqawm2f2jnq4hgplvewbda6b4amq successfully!

./lotus-miner init --genesis-miner --actor=t01000 --sector-size=2KiB --pre-sealed-sectors=~/.genesis-sectors --pre-sealed-metadata=~/.genesis-sectors/pre-seal-t01000.json --nosync
./lotus-miner run --nosync

```

## Try some commands

```
./lotus wallet list
Address                                                                                 Balance                         Nonce  Default  
t3qcyd47d3tyzuoz7fws5tiwbkvebkzvn7q33zolbvsmhhw52ui4gvr6gwwqawm2f2jnq4hgplvewbda6b4amq  49999999.99991597313833236 FIL  1      X        

./lotus-miner info
Enabled subsystems (from miner API): [Mining Sealing SectorStorage Markets]
Enabled subsystems (from markets API): [Mining Sealing SectorStorage Markets]
Chain: [sync behind! (2m16s behind)] [basefee 100 aFIL]
⚠ 1 Active alerts (check lotus-miner log alerts)
Miner: t01000 (2 KiB sectors)
Power: 40 Ki / 40 Ki (100.0000%)
	Raw: 4 KiB / 4 KiB (100.0000%)
	Committed: 4 KiB
	Proving: 4 KiB
Projected average block win rate: 20024.16/week (every 30s)
Projected block win with 99.9% probability every 41s
(projections DO NOT account for future network and miner growth)

Miner Balance:    8326.631 FIL
      PreCommit:  0
      Pledge:     2 aFIL
      Vesting:    6244.973 FIL
      Available:  2081.658 FIL
Market Balance:   0
       Locked:    0
       Available: 0
Worker Balance:   50000000 FIL
Total Spendable:  50002081.658 FIL

Sectors:
	Total: 2
	Proving: 2

Storage Deals: 0, 0 B

Retrieval Deals (complete): 0, 0 B

```

Import a local file into Lotus
```
./lotus client import /tmp/data/hello-1.1k.txt 
./lotus client local
# note the CID.
export CID=bafk2bzacebtdk5nhnzk7owatobzygsqkhidhbw5ddu4tltkf33uynhhfoe7pu

./lotus client stat $CID
```

Locate a miner and ask price.
```
./lotus state list-miners

./lotus client query-ask t01000

Ask: t01000
Price per GiB: 0.0000000005 FIL
Verified Price per GiB: 0.00000000005 FIL
Max Piece size: 2 KiB
Min Piece size: 256 B
```

> Caution: Interactive deals on Devnet seems to result in wrong deal duration.
```
./lotus client deal
./lotus client list-deals  --show-failed 
## Devnet error:
...deal rejected: deal duration out of bounds (min, max, provided): 518400, 1555200, 3890836
```

Make the Deal, non-interactive.
```
./lotus client deal $CID t01000 0.000000000462689374 518400

./lotus client get-deal $DEAL_ID
# Watch the deal progression.... be patien, takes quite awhile. Go do something else.
./lotus client list-deals -v --watch
```

> Takes overnight... still at status StorageDealSealing... Why?
> Add another deal to fill up the 2K sector?

```
./lotus client import /tmp/data/hello-1.1k-b.txt 
export CID=bafk2bzacecjdtqacqwggwebosmcbc67ymkj3ahrh4gwd5k7avoxyutpnvyi62
./lotus client deal $CID t01000 0.000000000462689374 518400
export DealCID=bafyreiabvuys62j5dbdpwznet2bgg2dpotd3hbadct6h3cdjwrqyvmrukq

./lotus client import /tmp/data/hello-1.1k-c.txt 
export CID=bafk2bzacec7wql7lo6c4fhfvb2ygviqcdzm3lx2eiufosghgwoeh3gzqvekyi
./lotus client deal $CID t01000 0.000000000462689374 518400
export DealCID=bafyreidhgh5z3ei2wy3vfzl7zr743xrmuppmlhxgdygofsalehcynxopva
```

Check Miner state:
```
./lotus-miner info
./lotus-miner storage-deals list -v
./lotus-miner data-transfers list
./lotus-miner pieces list-pieces
./lotus-miner pieces list-cids
./lotus-miner pieces cid-info $CID
./lotus-miner sectors list
./lotus-miner proving info
./lotus-miner storage list
./lotus-miner sealing jobs
./lotus-miner sealing workers
./lotus-miner sealing sched-diag
```

> Note 1 sealing worker but no jobs. Curious.
```
./lotus-miner sealing workers
./lotus-miner sealing jobs
```

# TODO

* Retry on Ubuntu Linux?
* Create a deal on Devnet?
* Investigate other lotus-miner commands?
* Investigate other binaries: lotus-worker, lotus-gateway, lotus-seed, lotus-shed, lotus-wallet?

* Investigate https://github.com/filecoin-project/lotus/discussions/categories/tutorials


# DevNet on Ubuntu.

Build Node, initialize, and fund wallet. As per https://docs.filecoin.io/build/local-devnet/#manual-set-up

```bash
# follow build instructions ...
./lotus-seed genesis add-miner localnet.json ~/.genesis-sectors/pre-seal-t01000.json
...Giving t3vssd22d3mvwzrz746qxoqxby4shvu6rdbfs4eb5kybi24n5okf2vz7mbirjzdbfeljpotqzgzrltt4d2qkua some initial balance
```

Start Node

```bash

export LOTUS_PATH=~/.lotusDevnet
export LOTUS_MINER_PATH=~/.lotusminerDevnet
export LOTUS_SKIP_GENESIS_CHECK=_yes_

./lotus daemon --lotus-make-genesis=devgen.car --genesis-template=localnet.json --bootstrap=false

```

Start Miner

```bash

export LOTUS_PATH=~/.lotusDevnet
export LOTUS_MINER_PATH=~/.lotusminerDevnet
./lotus-miner run --nosync

```

Play with miner commands:
```
./lotus-miner info
./lotus-miner log alerts

```



# Lotus Storage/Retrieval on Devnet

## CAR Storage
CAR file.
```
npx ipfs-car --pack root/root CID: bafybeihvgkltxopybikozrlpmyzxjdlsqb4ddarlasnxmhh7inuz3izmii
  output: root.car 

$ ./lotus client import --car ~/data/root.car 
Import 1646289942953632017, Root bafybeihvgkltxopybikozrlpmyzxjdlsqb4ddarlasnxmhh7inuz3izmii

./lotus client deal $CID t01000 0.000000000462689374 518400
bafyreie7z3ercarrdptapwhrixaix6nqxqa4fpbsmrtbjjffz4thphofc4

./lotus client list-deals 

./lotus-miner storage-deals list
./lotus-miner storage-deals pending-publish
# shows 1 hour to publish

# force publish 
./lotus-miner storage-deals pending-publish --publish-now

# Failed... create another deal.

$ ./lotus client list-deals --show-failed -v
# stuck in StorageDealAwaitingPreCommit

./lotus-miner sectors list
# sector stuck in "WaitDeals", lets force it to seal:
./lotus-miner sectors seal 2

./lotus-miner sectors list
# Sector status should move to PrecommitWait -> WaitSeed, CommitWait, Proving -> FinalizeSector

./lotus client list-deals  
# Deal is active. 

```

## Retrieval.

```
CID=bafybeihvgkltxopybikozrlpmyzxjdlsqb4ddarlasnxmhh7inuz3izmii
./lotus client find $CID 
./lotus client retrieve $CID retrieved-file.out
./lotus client retrieve --car $CID retrieved-car.out

# success.
```

