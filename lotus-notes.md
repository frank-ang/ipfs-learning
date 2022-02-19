# Node requirements.

## Lotus Node requirements.

* 8-core CPU and 32 GiB RAM. Intel SHA Extensions to speed things up.

* Storage: Lotus chain (preferably SSD).

    * chain grows at approximately 38 GiB per day (13.87 TB per year)

    * can be synced from trusted state snapshots and compacted or pruned to a minimum size of around 33Gib. The full history was around 10TiB in June of 2021.

    * AWS Pricing:

        ```
        Singapore Region.
        EC2: Linux, m5.2xlarge, on-demand,
            EC2 On-Demand instances (monthly): 350.40 USD
        EBS: gp3, 16TB
            EBS pricing (monthly): 1,572.86 USD
        Data Transfer: 1TB out
            Data Transfer cost (monthly): 122.88 USD
        Monthly cost: 2,046.14 USD
        Total 12 months cost: 24,553.68 USD
        ```

        [AWS Pricing Calculator](https://calculator.aws/#/estimate?id=4b8b7bd8587eec3c7cec11189732fe4b9cf2c25a)


## Lotus Miner requirements.

* CPU: 8-core. Intel SHA Extensions strongly recommended.
* RAM 128 GB RAM.
* powerful GPU is recommended to significantly speed up SNARK computations
* Storage: 
    * 256 GiB of swap on a very fast NVMe SSD 
    * Enough space to store the current Lotus chain (SSD preferred)
    * A minimal amount of 1TiB NVMe-based disk space for cache storage is recommended. 
        This disk should be used to store data during the sealing process, to cache Filecoin parameters and serve as general temporal storage location.

# 2022-02-11 Storage and Retrieval Tutorial. 

https://docs.filecoin.io/get-started/store-and-retrieve/set-up/#install-a-lite-node

## Broken on Mac

```sh
brew tap filecoin-project/lotus
brew install lotus
```

## Install and Run on Ubuntu

```sh
sudo snap install lotus-filecoi
export FULLNODE_API_INFO=wss://api.chain.love
/snap/bin/lotus-filecoin.lotus daemon --lite
```

## Below is broken?
```bash
export LOTUS_PATH=~/.lotusLite
export LOTUS_MINER_PATH=~/.lotusminerLite
FULLNODE_API_INFO=wss://api.chain.love 
lotus daemon --lite
```


# Glif JSON RPC API sample
```
curl --location --request POST 'https://api.node.glif.io/rpc/v0' \
--header 'Content-Type: application/javascript' \
--data-raw '{
"jsonrpc": "2.0",
"method": "Filecoin.ChainHead",
"id": 1,
"params": []
}'
```

# STORAGE

# Find SP from Filecoin Plus storage registry
http://lotus.filecoin.io.ipns.localhost:8080/docs/tutorials/store-and-retrieve/
https://plus.fil.org/
https://filrep.io/

Using the table, find a couple of storage providers that suit your needs. Try to find storage providers that are geographically close to you, minimum file size is lower than 5 GiB, and charge 0 FIL for verified deals.

```
s$ lotus client list-deals --show-failed
DealCid      DealId  Provider  State             On Chain?  Slashed?  PieceCID     Size       Price              Duration  Verified  
...iix6iqxi  0       f01247    StorageDealError  N          N         ...pl4ciwhy  7.938 GiB  0.00523308 FIL     523308    true      
  Message: unexpected deal status while waiting for data request: 11 (StorageDealFailing). Provider message: deal rejected: Sorry, we are currently not accepting deals! To store data with us, contact eric(at)chainsafe(dot)io
...7czfb75a  0       f0838467  StorageDealError  N          N         ...pl4ciwhy  7.938 GiB  0.00002612965 FIL  522593    true      
  Message: unexpected deal status while waiting for data request: 11 (StorageDealFailing). Provider message: deal rejected: storage price per epoch less than asking price: 50000000 < 400000000
...e3w4mazm  0       f071624   StorageDealError  N          N         ...pl4ciwhy  7.938 GiB  0.01049132 FIL     524566    true      
  Message: unexpected deal status while waiting for data request: 11 (StorageDealFailing). Provider message: deal rejected: miner is not considering online storage deals
...457fbvq4  0       f0838467  StorageDealError  N          N         ...pl4ciwhy  7.938 GiB  0.0002612885 FIL   522577    true      
  Message: unexpected deal status while waiting for data request: 11 (StorageDealFailing). Provider message: deal rejected: miner is not considering online storage deals
...jqewqolu  0       f0838467  StorageDealError  N          N         ...pl4ciwhy  7.938 GiB  0.002612815 FIL    522563    true      
  Message: unexpected deal status while waiting for data request: 11 (StorageDealFailing). Provider message: deal rejected: miner is not considering online storage deals



```

### Failed:
f01247
f0838467
f071624

### TODO:
f03488 : (3 deals): deal failed: (State=11) error calling node: publishing deal: publish validation failed: simulating deal publish message: apply message failed: All deal proposals invalid (RetCode=16)
f023467 :  Provider message: deal rejected: Deal rejected | Under maintenance, retry later 
f01278 : Provider message: deal rejected: Deal rejected | Price below acceptance for such deal : 0.0000001 FIL
f02576 : Provider message: deal rejected: Deal rejected | Such deal is not accepted (type, duration, size, etc...)
f023971 : Provider message: deal rejected: miner is not considering online storage deals
f022163 : Provider message: deal rejected: Deal rejected | Such deal is not accepted (type, duration, size, etc...)
f019551 : error waiting for deal pre-commit message to appear on chain: handling applied event: looking for publish deal message bafy2bzacec7dhtbywdtroq3jrwcyzgiovbdlrv6ccrkqljz42okrbn622egww: not found
f01234  : StorageDealFundsReserved -> failed: exhausted 15 attempts but failed to open stream, err: failed to dial 12D3KooWPWJemjphGa2pANr6j7HCaLyjUvCroHyTJsATY6TaCFAF:
f033356 : deal failed: (State=11) error calling node: publishing deal: publish validation failed: simulating deal publish message: apply message failed: All deal proposals invalid (RetCode=16)
f014768 : error waiting for deal pre-commit message to appear on chain: failed to set up called handler: called check error (h: 1561496): failed to look up deal on chain: looking for publish deal message bafy2bzacec36askonuylmy43vrvyghmlhfn3cffpyqywry3gwsnq2syzazf26: not found
f010088 : Provider message: deal rejected: miner is not considering online storage deals
f08403 : Provider message: deal rejected: Deal rejected | Such deal is not accepted (type, duration, size, etc...)
f0773157 : error waiting for deal pre-commit message to appear on chain: handling applied event: looking for publish deal message bafy2bzacedghd7xy6f4wvkxmo6enk4xijmluc4xj5yjdsigwhhlgqd2coi7tc: not found
f019399 : error waiting for deal pre-commit message to appear on chain: failed to set up called handler: called check error (h: 1561497): failed to look up deal on chain: looking for publish deal message bafy2bzacecyz4lzlqbxzszv2pehi2vymknc43taqmypu5akm2zftjzhrbnd5y: not found

```bash

# Find out the miner asks.
while read SPID; do echo "miner: $SPID" && timeout 5 lotus client query-ask "$SPID"; done < filplusminers.txt &> filplusminers.ask.out

# Create deals
CID=bafykbzacednsyqcdy2ppxuxyqwgdibe2ltg7mu2tiueh42fyh4uraalhtvc5c
SPID=<SPID>
DURATION=521826
# lotus client deal $CID $SPID 0.0 $DURATION
while read SPID; do echo "miner: $SPID" && lotus client deal --verified-deal=true $CID $SPID 0.0 $DURATION; done < filplusminers.txt &> filplusminers.deal.out

lotus client list-deals --show-failed
```


# Estuary troubleshooting
```
ipfs files cp /ipfs/bafybeighzt4uqbruigiyldnd7yryx7e7kbrrdd3za4nmaxs4foifnp55hi /random5G.txt	
ipfs files cp /ipfs/bafykbzacednsyqcdy2ppxuxyqwgdibe2ltg7mu2tiueh42fyh4uraalhtvc5c  /random5G.txt	
```
