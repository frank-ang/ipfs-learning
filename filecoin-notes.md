# Filecoin Node requirements.

## Filecoin Node requirements.

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


## Filecoin Miner requirements.

* CPU: 8-core. Intel SHA Extensions strongly recommended.
* RAM 128 GB RAM.
* powerful GPU is recommended to significantly speed up SNARK computations
* Storage: 
    * 256 GiB of swap on a very fast NVMe SSD 
    * Enough space to store the current Lotus chain (SSD preferred)
    * A minimal amount of 1TiB NVMe-based disk space for cache storage is recommended. 
        This disk should be used to store data during the sealing process, to cache Filecoin parameters and serve as general temporal storage location.

