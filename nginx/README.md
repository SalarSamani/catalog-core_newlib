# Nginx on Unikraft with Newlib 4.4 and Pthread-Embedded

This is a test to run nginx on Unikraft with Newlib 4.4 as LIBC and Pthread-Embedded.

## Quick Setup (aka TLDR)

For a quick setup, run the commands below.
Note that you still need to install the [requirements](../README.md#requirements).
Before everything, make sure you run the [top-level `setup.sh` script](../setup.sh).

**Note**: This is a network application.
For using QEMU, enable bridged networking, as instructed in the [top-level `README.md`](../README.md#qemu):

```console
echo "allow all" | sudo tee /etc/qemu/bridge.conf
```

To build and run the application for `x86_64`, use the commands below:

```console
./setup.sh
make distclean
cp newlibConfig .config
make -j $(nproc)
sudo modprobe bridge 2>/dev/null || true
sudo ip link add name virbr0 type bridge
sudo ip addr add 172.44.0.1/24 dev virbr0
sudo ip link set virbr0 up
ip addr show virbr0
test -f initrd.cpio || ./workdir/unikraft/support/scripts/mkcpio initrd.cpio ./rootfs/
sudo qemu-system-x86_64 \
    -nographic \
    -m 8 \
    -cpu max \
    -netdev bridge,id=en0,br=virbr0 -device virtio-net-pci,netdev=en0 \
    -append "nginx netdev.ip=172.44.0.2/24:172.44.0.1::: vfs.fstab=[ \"initrd0:/:extract::ramfs=1:\" ] -- -c /nginx/conf/nginx.conf" \
    -kernel workdir/build/nginx_qemu-x86_64 \
    -initrd ./initrd.cpio
```

## Test

To test Nginx on Unikraft, use `curl` (or any other HTTP client):

```console
curl 172.44.0.2
```

