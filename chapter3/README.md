# 动手实战Systemd

## 实验目的
* 熟悉Systemd的各种命令
* 动手实战Systemd

## 实验环境
* Ubuntu20.04
* 最新版本的vbox
* asciinema

## 实验过程
* [本次实验过程录制的视频](https://asciinema.org/~lsw666-gif)
* 一和二概述: [![一和二概述](https://asciinema.org/a/403613.svg)](https://asciinema.org/a/403613)
* 3.1：
* 3.2 systemd-analyze: [![3.2 systemd-analyze](https://asciinema.org/a/403598.svg)](https://asciinema.org/a/403598)
* 3.3 -3.5(3.5最后有点bug,会在下一期更正)：[![3.3-3.5](https://asciinema.org/a/403603.svg)](https://asciinema.org/a/403603)
* 3.5 -3.6：[![3.5-3.6](https://asciinema.org/a/403610.svg)](https://asciinema.org/a/403610)
* 4.1：[![4.1](https://asciinema.org/a/403617.svg)](https://asciinema.org/a/403617)
* 4.2：[![4.2](https://asciinema.org/a/403811.svg)](https://asciinema.org/a/403811)
* 4.3：[![4.3](https://asciinema.org/a/403816.svg)](https://asciinema.org/a/403816)
* 4.4: [![4.4](https://asciinema.org/a/403647.svg)](https://asciinema.org/a/403647)
* 5.1-5.4(5.4没有对应的代码): [![5.1-5.4](https://asciinema.org/a/403650.svg)](https://asciinema.org/a/403650)
* 6: [![6](https://asciinema.org/a/403653.svg)](https://asciinema.org/a/403653)
* 7: [![7](https://asciinema.org/a/403658.svg)](https://asciinema.org/a/403658)
* 实战篇 1-4（5，6没有代码）：[![实战篇 1-4（5，6没有代码）](https://asciinema.org/a/403690.svg)](https://asciinema.org/a/403690)
* 实战篇 7：[![实战篇 7](https://asciinema.org/a/404194.svg)](https://asciinema.org/a/404194)

## 实验碰到的问题
* 3.5中修改时间时，如果直接修改是不行的，因为系统默认同步时间；必须先关闭同步时间ntf=no可以解决
* 4.2中systemctl -H root@rhel7.example.com status httpd.service，root@rhel7.example.com要改成cuc@192.168.56.101
* 有的服务我是没有的，如httpd.service，可以用ufw.service.

## 自查清单
1. 如何添加一个用户并使其具备sudo执行程序的权限?
  sudo adduser demo 
  sudo usermod -G sudo -a demo

2. 如何将一个用户添加到一个用户组?
  sudo usermod -a -G groupname username

3. 如何查看当前系统的分区表和文件系统详细信息
  df -T -h (查看挂载的文件系统详细信息)
  sudo fdisk -l （显示各分区大小）

4. 如何实现开机自动挂载Virtualbox的共享目录分区：
   [此题参考链接](https://blog.csdn.net/hexf9632/article/details/93774198)
    1. 在windows下创建一个共享文件夹
    2. 打开共享文件夹选项
    3. 配置共享文件夹（只选择固定分配）
    4. 新建Ubuntu共享文件夹  ```sudo mkdir /mnt/dirname ```
    5. 执行挂载命令 ```sudo mount -t vboxsf [第一步共享文件夹名称] /mnt/dirname```
    6. 修改 /etc/fstab 文件 在文末添加```[Windows共享文件夹名称] /mnt/dirname/ vboxsf defaults 0 0```即可完成开机自动挂载
   
5. 基于LVM的分区如何实现动态扩容和缩减容量
  [此题参考链接](https://blog.csdn.net/weixin_34044273/article/details/92033124) 
  1. 首先得创建一个lvm
    1.制作VG
    pvcreate  /dev/vdb1
    2.制作VG（卷组）
    vgcreate  vg1 /dev/vdb1
    3.制作LV（逻辑卷）
    lvcreate   -n  lv1  -L  3G vg1
    4.格式化mkfs.ext4 /dev/vg1/lv1
    5.挂载mount  /dev/vg1/lv1   /opt/
  2. 动态扩容
    逻辑卷扩展：lvextend   -L   +300M     /dev/vg1/lv1
    resize2fs   /dev/vg1/lv1     扩展文件系统
  3. 缩减容量
    1、先卸载umount   /opt/                   #卸载不影响里面的资料
    2、e2fsck    -f   /dev/vg1/lv1            #检查文件系统是否正常工作
    如：将10G缩减到8G
    resize2fs      /dev/vg1/lv1    8G           #这个8G指的是缩小后的大小
    lvreduce   -L    8G   /dev/vg1/lv1
    mount    /dev/vg1/lv1  /opt/                  #挂载后发现里面的数据依然还在

6. 如何通过systemd设置实现在网络连通时运行一个指定脚本，在网络断开时运行另一个脚本？
    修改systemd-networkd中的Service
	  ExecStartPost=网络联通时运行的指定脚本
    ExecStopPost=网络断开时运行的另一个脚本
    
7. 如何通过systemd设置实现一个脚本在任何情况下被杀死之后会立即重新启动？实现杀不死？
    sudo systemctl vi scriptname
    Restart = always
    sudo systemctl daemon-reload



