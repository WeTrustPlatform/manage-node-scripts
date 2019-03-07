# manage-node-scripts
A collection of scripts to manage Ethereum nodes

### Download geth
```
./dowload-geth 1.8.23
# The downloaded binary is in ./tmp
sudo cp tmp/<package-name>/geth /usr/bin/
```

Why do I need this script?
- It verifies MD5 checksums.
- It verifies GPG signatures.
- It unzips for you.
- Only thing you need to do is specify the version.
