mkisofs -r -T -J -V "CentosKSTest" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -v -o ~/Workspace/loganov/centos64.iso .

