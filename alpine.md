휴대폰 서버는 막히는 게 너무 많습니다.<br>
평범한 방법으로는 도커 설치 안됩니다.<br>
그래서 리눅스에 에뮬레이터로 한 번 더 가상화 하여 도커를 설치할 겁니다.<br>
이건 먹히거든요.<br><br>

## QEMU 관련 패키지 설치
```
pkg install qemu-utils qemu-common qemu-system-x86_64-headless
```
<br><br>

## termux-qemu VM image 생성
```
qemu-img create -f qcow2 alpine.img 20g
```
뒤에 있는 alpine 가상머신 용량입니다.<br>
휴대폰 용량이 빵빵하면 50g 100g로 해도 됩니다.
<br><br>

## Alpine 가상머신 파일 가져오기
```
wget https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/x86_64/alpine-virt-3.15.3-x86_64.iso
wget https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-virt-3.20.3-x86_64.iso
```

둘 중 마음에 드는 거 선택하세요.<br>
여기까지 명령어는 입력하기 귀찮을테니 실행파일 만들어놨습니다.<br>
마음에 드는거 골라 쓰세요.<br>

단, 여기 명시된 건 반드시 반드시 동일해야합니다.
```
alpine-virt-3.15.3-x86_64.iso
alpine-virt-3.20.3-x86_64.iso
```

## 가상머신 구동하기
qemu-system-x86_64 -machine q35 -m 2048 -smp cpus=4 -cpu qemu64 \
-drive if=pflash,format=raw,read-only=on,file=$PREFIX/share/qemu/edk2-x86_64-code.fd \
-netdev user,id=n1,hostfwd=tcp::2222-:22 \
-device virtio-net,netdev=n1 \
-cdrom alpine-virt-3.15.3-x86_64.iso \
-nographic alpine.img

cdrom을 만들어서 굽고 생성하는 과정입니다.<br>
시간이 정말 오래 걸립니다.<br>
7년된 구닥다리 노트8로 생성하는데 대략 5~6분 걸린 거 같네요.<br><br>
기다리면 root로 로그인하면 됩니다.<br>
이제 몇 가지 설정을 진행해야 합니다.

## alpine 설정하기 (존나 길다)
```
setup-alpine
```
- keyboard layout은 us로 설정
- varaint도 us로 설정
<br>

```
localhost:~# setup-alpine
Available keyboard layouts:
af     be     cn     fi     hu     it     lk     mm     pl     sy     uz
al     bg     cz     fo     id     jp     lt     mt     pt     th     vn
am     br     de     fr     ie     ke     lv     my     ro     tj
ara    brai   dk     gb     il     kg     ma     ng     rs     tm
at     by     dz     ge     in     kr     md     nl     ru     tr
az     ca     ee     gh     iq     kz     me     no     se     tw
ba     ch     epo    gr     ir     la     mk     ph     si     ua
bd     cm     es     hr     is     latam  ml     pk     sk     us
Select keyboard layout: [none] us
Available variants: us-alt-intl us-altgr-intl us-chr us-colemak us-colemak_dh us-colemak_dh_iso us-dvorak-alt-intl us-dvorak-classic us-dvorak-intl us-dvorak-l us-dvorak-mac us-dvorak-r us-dvorak us-dvp us-euro us-haw us-hbs us-intl us-mac us-norman us-olpc2 us-rus us-symbolic us-workman-intl us-workman us
Select variant (or 'abort'): us
```
<br><br>

```
Available variants: us-alt-intl us-altgr-intl us-chr us-colemak us-colemak_dh us-colemak_dh_iso us-dvorak-alt-intl us-dvorak-classic us-dvorak-intl us-dvorak-l us-dvorak-mac us-dvorak-r us-dvorak us-dvp us-euro us-haw us-hbs us-intl us-mac us-norman us-olpc2 us-rus us-symbolic us-workman-intl us-workman us
Select variant (or 'abort'): us
 * Caching service dependencies ...

 [ ok ]
 * Setting keymap ...
 [ ok ]
Enter system hostname (fully qualified form, e.g. 'foo.example.org') [localhost] Available interfaces are: eth0.
Enter '?' for help on bridges, bonding and vlans.
Which one do you want to initialize? (or '?' or 'done') [eth0]
Ip address for eth0? (or 'dhcp', 'none', '?') [dhcp]
Do you want to do any manual network configuration? (y/n) [n]
```
<br>

- 이후 나오는 것들은 전부 쌩까고 엔터 누릅니다<br>

```
udhcpc: started, v1.34.1
udhcpc: broadcasting discover
udhcpc: broadcasting select for 10.0.2.15, server 10.0.2.2
udhcpc: lease of 10.0.2.15 obtained from 10.0.2.2, lease time 86400
Changing password for root
New password:
```
<br>

- 패스워드는 자유롭게 설정

```
passwd: password for root changed by root
Which timezone are you in? ('?' for list) [UTC] ?
Africa/      Chile/       GB-Eire      Israel       Navajo       US/
America/     Cuba         GMT          Jamaica      PRC          UTC
Antarctica/  EET          GMT+0        Japan        PST8PDT      Universal
Arctic/      EST          GMT-0        Kwajalein    Pacific/     W-SU
Asia/        EST5EDT      GMT0         Libya        Poland       WET
Atlantic/    Egypt        Greenwich    MET          Portugal     Zulu
Australia/   Eire         HST          MST          ROC          posixrules
Brazil/      Etc/         Hongkong     MST7MDT      ROK          right/
CET          Europe/      Iceland      Mexico/      Singapore
CST6CDT      Factory      Indian/      NZ           Turkey
Canada/      GB           Iran         NZ-CHAT      UCT
Which timezone are you in? ('?' for list) [UTC]
```

- 타임존은 Asia로 들어가서 Seoul 입력.


```
Enter mirror number (1-90) or URL to add (or r/f/e/done) [1]
Added mirror dl-cdn.alpinelinux.org
Updating repository indexes... done.
Which SSH server? ('openssh', 'dropbear' or 'none') [openssh]
 * service sshd added to runlevel default
 * Caching service dependencies ...
 [ ok ]
ssh-keygen: generating new host keys: RSA DSA ECDSA ED25519
 * Starting sshd ...
 [ ok ]
Available disks are:
  sda   (21.5 GB ATA      QEMU HARDDISK   )
Which disk(s) would you like to use? (or '?' for help or 'none') [none] sda
The following disk is selected:
  sda   (21.5 GB ATA      QEMU HARDDISK   )
How would you like to use it? ('sys', 'data', 'crypt', 'lvm' or '?' for help) [?] sys
WARNING: The following disk(s) will be erased:
  sda   (21.5 GB ATA      QEMU HARDDISK   )
WARNING: Erase the above disk(s) and continue? (y/n) [n] y
```
<br>

- 디스크 설정하는 겁니다. 순서는 아래와 같습니다.
1. sda를 입력한다 (어떤 디스크를 쓸 건가요?)
2. sys를 입력한다 (해당 디스크는 어떤 용도로 쓸 건가요?)
3. y를 입력한다. (포맷 함 때릴 거에요?)


<br>
모든 과정이 끝났으면 이제 종료합니다.
```
poweroff
```
시스템 종료하는 것처럼, 이 친구도 종료 시간 꽤 있습니다.
기다리면 알아서 종료돼요.
<br><br>

## cdrom 없이 실행하기
여기까지 왔으면 가상머신 설치는 끝났습니다.<br>
이제 cdrom 필요없이 가상머신을 실행할 수 있습니다.

```
qemu-system-x86_64 -machine q35 -m 2048 -smp cpus=4 -cpu qemu64 \
-drive if=pflash,format=raw,read-only=on,file=$PREFIX/share/qemu/edk2-x86_64-code.fd \
-netdev user,id=n1,hostfwd=tcp::2222-:22 \
-device virtio-net,netdev=n1 \
-nographic alpine.img
```
<br>
cpus는 코어 갯수입니다.
내 폰 코어 갯수 궁금하면 아래 명령어 입력하세요.
```
echo $(nproc)
```

저거 일일이 입력하기 귀찮죠?<br> 
"termux_alpine_exeucte.sh" 파일 하나 만들어놨으니,<br>
그거 그냥 실행하세요.<br>
cdrom 유무 구분해놨습니다.<br>
당연 실행 안되면 알죠? 모드 적용하는거.<br>
