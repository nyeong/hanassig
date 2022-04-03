# PCI 패스스루

그래픽카드와 같이 PCI로 연결되는 장치를 VM에 직결하는 기술. 패스스루 하게 되면 호스트나 다른 VM에서의 사용이 제한된다.

## ODROID H2 GPU 패스스루

### IOMMU 활성화

`grub`에 인텔 CPU를 사용할 경우의 설정 방법이다.

`/etc/default/grub` 파일에서 아래의 설정을 찾아 아래와같이 옵션을 바꿔준다.

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on video=efifb:off iommu=pt"
```

```
$ update-grub
$ reboot
```

### 커널 모듈 불러오기

`/etc/modules` 파일에 다음 내용을 추가한다.

```
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

`initramfs`를 새로고침한다.

```
$ update-initramfs -u -k all
```

### IOMMU 인터럽트 리매핑

리매핑이 가능해야 패스스루가 가능하므로 리매핑 가능 여부를 확인한다.

```
$ sudo dmesg | grep remapping
[    0.132566] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.134491] DMAR-IR: Enabled IRQ remapping in x2apic mode
```

`DMAR-IR: Enable IRQ remapping`으로 리매핑 가능한 것을 확인하였다.

### 호스트 드라이버 블락

`/etc/modprobe.d/pve-blacklist.conf` 파일에 아래 내용을 추가하여 내장 드라이버 사용을 막는다.

```
blacklist snd_hda_intel
blacklist snd_hda_codec_hdmi
blacklist i915
```

`/etc/modprobe.d/vfio.conf` 파일에 아래 내용을 추가하여 `vfio-pci` 드라이버를 사용하도록 한다.
`disable_vga=1` 옵션은 사용할 게스트의 BIOS가 OVMF인 경우에 체크한다.

```
options vfio-pci ids=8086:3185 disable_vga=1
```

`8086:3185`는 벤더/디바이스 ID로, 아래의 명령어로 확인할 수 있다.

```
$ lspci -nn | grep VGA
```

설정 후 `initramfs` 업데이트 후 재부팅한다.

```
$ update-initramfs -u -k all
```

### 게스트 설정

`/etc/pve/qemu-server/[VMID].conf` 파일에서 게스트 머신을 설정한다.

```
bias: ovmf
scsihw: virtio-scsi-pci
scsi0: ...
hostpci0: 02:00,x-vga=on
```

## 참고

- [DJJ PROJECT/Proxmox J5005 GPU 패쓰쓰루](https://blog.djjproject.com/740)
- [proxmox/PCI(e) Passthrough](https://pve.proxmox.com/wiki/PCI(e)_Passthrough)
- [Odroid H2 + Proxmox VE 사용기](https://www.clien.net/service/board/cm_nas/14375704)
