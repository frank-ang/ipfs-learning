# Lotus Changing Networks.

# Devnet setup.

Assumed Starting point. Already setup.  

# Mainnet setup

1. Build
```
cd lotus
make clean all
./lotus --version
sudo make install
```

2. Run
```
export LOTUS_PATH=$HOME/.lotusLite
FULLNODE_API_INFO=wss://api.chain.love lotus daemon --lite
```

Set environment variables for lotus client too.

Or, for convenience:

```
lite/lotus-lite.sh
```

3. Interact.

```
export LOTUS_PATH=$HOME/.lotusLite

lotus filplus list-notaries | wc -l
lotus filplus list-clients | wc -l
lotus state list-miners | wc -l  # 587438! Why so many?
lotus state network-version


```
4. Wallet

```
lotus wallet new
f1dv5aqd4tdax3iryqgp6n5bcoa7bdiow7xmp3sba
f1wxtayf5qk64fe32vcmp6tg5cuxl45so2q7zg55q

lotus wallet list
Address                                    Balance    Nonce  Default  
f1dv5aqd4tdax3iryqgp6n5bcoa7bdiow7xmp3sba  0.099 FIL  0      X        
f1wxtayf5qk64fe32vcmp6tg5cuxl45so2q7zg55q  0 FIL      0      

lotus wallet list
Address                                    Balance                   Nonce  Default  
f1dv5aqd4tdax3iryqgp6n5bcoa7bdiow7xmp3sba  0.087973874942146994 FIL  1      X        
f1wxtayf5qk64fe32vcmp6tg5cuxl45so2q7zg55q  0.01 FIL                  0     

lotus wallet export f1wxtayf5qk64fe32vcmp6tg5cuxl45so2q7zg55q > f1wxtayf5qk64fe32vcmp6tg5cuxl45so2q7zg55q.wallet.export

lotus wallet delete f1wxtayf5qk64fe32vcmp6tg5cuxl45so2q7zg55q
```




5. Backup Wallet.


# Make deals on mainnet

1. Import data

```
dd if=/dev/urandom of=/tmp/data/5gb-filecoin-payload.bin bs=1m count=5200
lotus client import /tmp/data/5gb-filecoin-payload.bin
# Make a note of the Data CID.
# Import 1648622252229478001, Root bafykbzacedkwdozcampcvvhwvcb4qwgpfyeoz7ammzbhmdgv6sz6uvzmawzqm

```

2. Select Storage Providers 

Select candidates, using starboard
https://sprd.starboard.ventures/contrast

f01606675 - failed to complete data transfer
f01111110
f01602479 - 

```
lotus client query-ask $MINER
```

Ask: f01606675
Price per GiB: 0 FIL
Verified Price per GiB: 0 FIL
Max Piece size: 32 GiB
Min Piece size: 256 B

Ask: f01602479
Price per GiB: 0 FIL
Verified Price per GiB: 0 FIL
Max Piece size: 32 GiB
Min Piece size: 256 B

---
f01392893
f01707840
f01652952





3. Deal
```
lotus client local
1648622252229478001: bafykbzacedkwdozcampcvvhwvcb4qwgpfyeoz7ammzbhmdgv6sz6uvzmawzqm @/tmp/data/5gb-filecoin-payload.bin (import)

CID=bafykbzacedkwdozcampcvvhwvcb4qwgpfyeoz7ammzbhmdgv6sz6uvzmawzqm
SPID=<SPID>
DURATION=521826
WALLET=f1rtkzbu6p2z2jovle3cdit7sri74rfdsm56x33ga

lotus client deal --verified-deal=true --from=$WALLET $CID $SPID 0.0 $DURATION
```

---
Monitor
```
bafyreigg7ds7jpplsqvy4djyycoqapmb63v2cuk4lplolbz6w5ylnupxpu

# monitor data transfer. BE PATIENT!
while true; do; date; lotus client list-transfers; sleep 120; done

# monitor deal status
while true; do; date; lotus client list-deals --show-failed ; sleep 120; done
# or watch:
lotus client list-deals --show-failed --watch

```

Observe deal progression:
* StorageDealTransferring
* StorageDealCheckForAcceptance
* 
