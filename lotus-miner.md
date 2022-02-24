# Lotus Miner Notes.

https://docs.filecoin.io/build/local-devnet/#manual-set-up

# Try on Mac.

## Node terminal session.
```
export LOTUS_PATH=~/.lotusDevnet
export LOTUS_MINER_PATH=~/.lotusminerDevnet

# Build on Mac
git checkout v1.14.1
export LIBRARY_PATH=/opt/homebrew/lib # will this help with rclone?
export FFI_BUILD_FROM_SOURCE=1
make 2k

# configuration
export LOTUS_SKIP_GENESIS_CHECK=_yes_
./lotus fetch-params 2048
./lotus-seed pre-seal --sector-size 2KiB --num-sectors 2
./lotus-seed genesis new localnet.json
./lotus-seed genesis add-miner localnet.json ~/.genesis-sectors/pre-seal-t01000.json

...Adding miner t01000 to genesis template
...Giving t3u3sycrnnfzqm3xlcngy6upvv7goqzuhxa256isd35fzlxzm34alos3ouwoie4npcjj53q34d3rkagcpewu7a some initial balance


# start the first node.
./lotus daemon --lotus-make-genesis=devgen.car --genesis-template=localnet.json --bootstrap=false

```

## Miner (Storage Provider) session.
```
export LOTUS_PATH=~/.lotusDevnet
export LOTUS_MINER_PATH=~/.lotusminerDevnet
./lotus wallet import --as-default ~/.genesis-sectors/pre-seal-t01000.key
./lotus-miner init --genesis-miner --actor=t01000 --sector-size=2KiB --pre-sealed-sectors=~/.genesis-sectors --pre-sealed-metadata=~/.genesis-sectors/pre-seal-t01000.json --nosync
./lotus-miner run --nosync

```

> Error: failed to compute winning post proof: faulty sectors.
Appears to be a bug.

```
2022-02-24T10:09:04.648+0800	INFO	storageminer	storage/miner.go:291	Computing WinningPoSt ;[{SealProof:5 SectorNumber:0 SectorKey:<nil> SealedCID:bagboea4b5abca64vmvq2bieln33ovt4ktqocm36ndeouuvk2yervyqk6t3ulkdyl}]; [123 156 113 9 104 3 192 241 244 234 238 195 2 195 179 137 200 185 133 217 46 237 12 26 250 175 209 182 121 132 133 82]
2022-02-24T10:09:04.658+0800	ERROR	miner	miner/miner.go:475	completed mineOne	{"tookMilliseconds": 15, "forRound": 152, "baseEpoch": 151, "baseDeltaSeconds": 1692056, "nullRounds": 0, "lateStart": true, "beaconEpoch": 1618181, "lookbackEpochs": 900, "networkPowerAtLookback": "40960", "minerPowerAtLookback": "40960", "isEligible": true, "isWinner": true, "error": "failed to compute winning post proof: faulty sectors [SectorId(0)]", "errorVerbose": "failed to compute winning post proof:\n    github.com/filecoin-project/lotus/miner.(*Miner).mineOne\n        /Users/frankang/lab/lotus/miner/miner.go:545\n  - faulty sectors [SectorId(0)]\n    github.com/filecoin-project/filecoin-ffi.GenerateWinningPoSt\n    \t/Users/frankang/lab/lotus/extern/filecoin-ffi/proofs.go:643\n    github.com/filecoin-project/lotus/extern/sector-storage/ffiwrapper.(*Sealer).GenerateWinningPoSt\n    \t/Users/frankang/lab/lotus/extern/sector-storage/ffiwrapper/verifier_cgo.go:32\n    github.com/filecoin-project/lotus/storage.(*StorageWpp).ComputeProof\n    \t/Users/frankang/lab/lotus/storage/miner.go:294\n    github.com/filecoin-project/lotus/miner.(*Miner).mineOne\n    \t/Users/frankang/lab/lotus/miner/miner.go:543\n    github.com/filecoin-project/lotus/miner.(*Miner).mine\n    \t/Users/frankang/lab/lotus/miner/miner.go:285\n    runtime.goexit\n    \t/opt/homebrew/Cellar/go/1.17.6/libexec/src/runtime/asm_arm64.s:1133"}
2022-02-24T10:09:04.658+0800	ERROR	miner	miner/miner.go:287	mining block failed: failed to compute winning post proof:
    github.com/filecoin-project/lotus/miner.(*Miner).mineOne
        /Users/frankang/lab/lotus/miner/miner.go:545
  - faulty sectors [SectorId(0)]
    github.com/filecoin-project/filecoin-ffi.GenerateWinningPoSt
    	/Users/frankang/lab/lotus/extern/filecoin-ffi/proofs.go:643
    github.com/filecoin-project/lotus/extern/sector-storage/ffiwrapper.(*Sealer).GenerateWinningPoSt
    	/Users/frankang/lab/lotus/extern/sector-storage/ffiwrapper/verifier_cgo.go:32
    github.com/filecoin-project/lotus/storage.(*StorageWpp).ComputeProof
    	/Users/frankang/lab/lotus/storage/miner.go:294
    github.com/filecoin-project/lotus/miner.(*Miner).mineOne
    	/Users/frankang/lab/lotus/miner/miner.go:543
    github.com/filecoin-project/lotus/miner.(*Miner).mine
    	/Users/frankang/lab/lotus/miner/miner.go:285
    runtime.goexit
    	/opt/homebrew/Cellar/go/1.17.6/libexec/src/runtime/asm_arm64.s:1133
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

TODO, now what?
