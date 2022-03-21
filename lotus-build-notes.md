# Lotus on MacOS

https://lotu.sh/docs/set-up/install/#build-from-source

https://lotus.filecoin.io/docs/set-up/switch-networks/

https://docs.filecoin.io/build/local-devnet/#manual-set-up



```bash

# Install other prereqs.
brew install bzr pkg-config hwloc

# checkout a specific stable tag.
git status
HEAD detached at v1.13.2

# for MAC ARM Architecture
export LIBRARY_PATH=/opt/homebrew/lib
export FFI_BUILD_FROM_SOURCE=1
# use temp values
export LOTUS_PATH=~/.lotusDevnet
export LOTUS_MINER_PATH=~/.lotusminerDevnet
# make using 2KB sectors. 
make 2k

# success, now install binaries to /usr/local/bin

make install
#install -C ./lotus /usr/local/bin/lotus
#install -C ./lotus-miner /usr/local/bin/lotus-miner
#install -C ./lotus-worker /usr/local/bin/lotus-worker

```

## Start daemon on local dev-net.

https://docs.filecoin.io/build/local-devnet/#manual-set-up

```bash
export LOTUS_PATH=~/.lotusDevnet
export LOTUS_MINER_PATH=~/.lotusminerDevnet
export LOTUS_SKIP_GENESIS_CHECK=_yes_

```

### Grab the 2048 byte parameters:

```bash
./lotus fetch-params 2048
```
This took an hour or so and downloaded 1.4G of tmp files into ```/var/tmp/filecoin-proof-parameters/```


```
./lotus-seed pre-seal --sector-size 2KiB --num-sectors 2
./lotus-seed genesis new localnet.json
./lotus-seed genesis add-miner localnet.json ~/.genesis-sectors/19:56:16:~/
```

Add FIL.
```
lab/lotus % ./lotus-seed genesis add-miner localnet.json ~/.genesis-sectors/pre-seal-t01000.json

2022-02-04T19:56:29.192+0800	INFO	lotus-seed	lotus-seed/genesis.go:129	Adding miner t01000 to genesis template
2022-02-04T19:56:29.192+0800	INFO	lotus-seed	lotus-seed/genesis.go:146	Giving t3ubbapplvpd5mxpvkeaggm45wfmbjmi2a5v2pvmd3mt5pu5ejphqx2idvmoeireqvsw5ymxa4anc73d5onedq some initial balance
```

> Node in a 1st terminal..

Start the first node
```
./lotus daemon --lotus-make-genesis=devgen.car --genesis-template=localnet.json --bootstrap=false

```

> Miner in a 2nd terminal.

Import the genesis miner key:
```
./lotus wallet import --as-default ~/.genesis-sectors/pre-seal-t01000.key
```

Set up the genesis miner. This process can take a few minutes:

```
./lotus-miner init --genesis-miner --actor=t01000 --sector-size=2KiB --pre-sealed-sectors=~/.genesis-sectors --pre-sealed-metadata=~/.genesis-sectors/pre-seal-t01000.json --nosync
```

Start the miner
```
./lotus-miner run --nosync

```

## Misc notes.

Fix build error:

```bash
# github.com/zondax/hid
In file included from ../../go/pkg/mod/github.com/zondax/hid@v0.9.0/hid_enabled.go:38:
../../go/pkg/mod/github.com/zondax/hid@v0.9.0/hidapi/mac/hid.c:693:34: warning: 'kIOMasterPortDefault' is deprecated: first deprecated in macOS 12.0 [-Wdeprecated-declarations]
/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/IOKit.framework/Headers/IOKitLib.h:123:19: note: 'kIOMasterPortDefault' has been explicitly marked deprecated here
make: *** [lotus] Error 2

# Fix: https://github.com/filecoin-project/lotus/issues/7597
Edit file:
```$HOME/go/pkg/mod/github.com/zondax/hid@v0.9.0/hid/hidapi/mac/hid.c```
# replace "kIOMasterPortDefault" with "kIOMainPortDefault"

```

# Find Suitable Miners

```sh
lotus state list-miners > miners.out
while read in; do echo "miner: $in" && timeout 5 lotus client query-ask "$in"; done < miners.out &> query-ask.out
## Most will be uncontactable. Find the asks.
grep -A 4 '^Ask: f' query-ask.out > miner-ask.out
## Find those with reasonable costs.
```


