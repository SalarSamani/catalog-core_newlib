# Python3 Hello on Unikraft with Newlib 4.4 and Pthread-Embedded

This is a test to run python3 on Unikraft with Newlib 4.4 as LIBC and Pthread-Embedded.

## Quick Setup

For a quick setup, run the commands below.
Note that you still need to install the [requirements](../README.md#requirements).
Before everything, make sure you run the [top-level `setup.sh` script](../setup.sh).

To build and run the application for `x86_64`, use the commands below:

```console
./setup.sh
make distclean
cp newlibConfig .config
make -j $(nproc)
test -d ./rootfs/ || docker build -o ./rootfs -f Dockerfile .
rm -fr ./9pfs-rootfs
cp -r ./rootfs ./9pfs-rootfs
qemu-system-x86_64 \
    -nographic \
    -m 256 \
    -cpu max \
    -fsdev local,id=myid,path=$(pwd)/9pfs-rootfs/,security_model=none \
    -device virtio-9p-pci,fsdev=myid,mount_tag=fs0 \
    -append "python3-hello_qemu-x86_64 vfs.fstab=[ \"fs0:/:9pfs:::\" ] env.vars=[ PYTHONPATH=\"/usr/local/lib/python3.10:/usr/local/lib/python3.10/site-packages\" ] -- /app/hello.py" \
    -kernel workdir/build/python3-hello_qemu-x86_64
```

