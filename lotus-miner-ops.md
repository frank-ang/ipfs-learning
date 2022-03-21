# Miner ops

# troubleshooting windows post.

https://filecoinproject.slack.com/archives/CPFTWMY7N/p1646835609905299
I found the following command that is supposedly meant to tell you if you will pass post - but it returns a 0. I can't say that the command ... is factually useful at determining if a POST will succeed. 
```
lotus@miner:~$ lotus-miner pprof goroutines | grep 'FilGenerateWindowPost.func1 ' | wc -l
0
```

https://filecoinproject.slack.com/archives/CPFTWMY7N/p1635433791315000?thread_ts=1635429273.313400&cid=CPFTWMY7N
This will cmd will check each sector:
```
lotus-miner proving check --slow 0
# with RUST_LOG=debug
```

ZFS check
```
zpool status -v 
```

