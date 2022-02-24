# web3.storage

[https://web3.storage](https://web3.storage)

Uploaded and pinned 3 image files on 2022-01-10.


# nft.storage

Uploaded 1 image file on 2022-01-12

> Observations: Web3.storage preserves filename.

* Noted the CID is different from same file on web3.storage. 
    * web3.storage: Sintel Poster.jpg https://bafybeicaaz46ct33lbn4uqsrnrtjwkllxmnv2x3tefzmgrikdd7hikd3jq.ipfs.dweb.link/
    * nft.storage:  Sintel Poster.jpg https://bafkreiavhz7f2oj4x3dxrxiubn7k67nbepomb7op7xajnuesveht5i4jza.ipfs.dweb.link/
* Dupe file uploads to same site:
    * NFT.storage generates same CID dupe. Does not preserve filename.
    * Web3.storage generates different CID for dupe. Preserves filename.

# Slate (WWW client for Filecoin / IPFS : seems to have issues)

[https://slate.host/](https://slate.host/)

2022-01-12: uploaded 2 image files.
Unable to find option to create Filecoin storage deal.
Project issues by jimmylee: https://github.com/filecoin-project/slate/issues/409

# IPFS Pinning services:

## Pinata (IPFS pinning service.)

Added 1 file.

Other pinning services:
* [Infura](https://infura.io/)
* [Temporal](https://temporal.cloud/)
* [Eternum](https://eternum.io) 

# Fleek (hosting)

Published example SPA website on 2021-11-23.

Github: https://github.com/frank-ang/fleek-my-app/tree/master
Site: https://frosty-waterfall-0669.on.fleek.co/
Browser IPFS plugin redirect to local running node: http://frosty-waterfall-0669.on.fleek.co.ipns.localhost:8080/ 

Still Pending Filecoin Deal as of 2022-01-12

# Textile Hub

Installed hub CLI.
```hub init``` to franklogic

Initialize bucket.
```sh
% hub login
Enter your username or email: franklogic█
> We sent an email to the account address. Please follow the steps provided inside it.
✔ Email confirmed
> Success! You are now logged in. Initialize a new bucket with `hub buck init`.
frankang@Franks-MBP bucket1 % hub buck init
Enter a name for your new bucket (optional): bucket1█
✗ Encrypt bucket contents: 
> Selected threadDB bafkzgbg5ow2nhqfph3ub6q4ky4unfflijjwa5szwgyjayg7mxqg7e4i

> Your bucket links:
> https://hub.textile.io/thread/bafkzgbg5ow2nhqfph3ub6q4ky4unfflijjwa5szwgyjayg7mxqg7e4i/buckets/bafzbeigd63guhsa5afceldpmcemcbnkx223mnexvrfcmhodgh5a43db3km Thread link
> https://hub.textile.io/ipns/bafzbeigd63guhsa5afceldpmcemcbnkx223mnexvrfcmhodgh5a43db3km IPNS link (propagation can be slow)
> https://bafzbeigd63guhsa5afceldpmcemcbnkx223mnexvrfcmhodgh5a43db3km.textile.space Bucket website
> Success! Initialized /Users/frankang/lab/noodling/textile-hub/bucket1 as a new empty bucket

```

Create keys
```
hub key create 
```

Init bucket.
```
% cd bucket1
% hub buck init

% hub buck existing

  NAME     THREAD                                                    KEY                                                          ROOT                                                         
  bucket1  bafkzgbg5ow2nhqfph3ub6q4ky4unfflijjwa5szwgyjayg7mxqg7e4i  bafzbeigd63guhsa5afceldpmcemcbnkx223mnexvrfcmhodgh5a43db3km  bafybeidvz4aqw5p4lvibllhuhadlptw6dpjdfvcflnt5wrspygavtvavcy  

% hub bucket links
> Your bucket links:
> https://hub.textile.io/thread/bafkzgbg5ow2nhqfph3ub6q4ky4unfflijjwa5szwgyjayg7mxqg7e4i/buckets/bafzbeigd63guhsa5afceldpmcemcbnkx223mnexvrfcmhodgh5a43db3km Thread link
> https://hub.textile.io/ipns/bafzbeigd63guhsa5afceldpmcemcbnkx223mnexvrfcmhodgh5a43db3km IPNS link (propagation can be slow)
> https://bafzbeigd63guhsa5afceldpmcemcbnkx223mnexvrfcmhodgh5a43db3km.textile.space Bucket website

hub buck push
# this pushes any changes, e.g. a hello.txt file.
```

Download from other directory:
```
cd somewhere-else
hub bucket init --existing
hub pull

```

Archive to Filecoin
```sh

base64 /dev/urandom | head -c 500000000 > 500mb-random.dat
hub buck push

# check wallet balance
hub fil addrs

# send funds from a lotus wallet 
lotus send <address> 0.05

# archive (interactive)
hub buck archive

# Check status: "archiveStatus": "ARCHIVE_STATUS_EXECUTING",...
hub buck archive list


```