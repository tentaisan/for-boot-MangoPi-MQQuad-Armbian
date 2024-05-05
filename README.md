```
sudo dd if=/opt/result/u-boot-sunxi-with-spl.bin of=/dev/sdxx bs=8K seek=1
sudo cp /opt/result/sun50i-h616-mangopi-mq-quad.dtb $BOOTDEV/armbi_root/boot/dtb/allwinner/
```