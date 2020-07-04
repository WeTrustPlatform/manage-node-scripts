# manage-node-scripts

A collection of scripts to manage Ethereum nodes

### Download geth

- A specific version

```
wget --no-cache -qO- https://raw.githubusercontent.com/WeTrustPlatform/manage-node-scripts/master/download-geth.sh | bash -s -- 1.9.15
```

- Latest geth

```
wget --no-cache -qO- https://raw.githubusercontent.com/WeTrustPlatform/manage-node-scripts/master/download-geth.sh | bash
```

- Copy the binary to path

```
  sudo cp geth /usr/local/bin/
```

Why do I need this script?

- It verifies MD5 checksums.
- It verifies GPG signatures.
- It unzips for you.
- Only thing you need to do is executing `./download-geth`
