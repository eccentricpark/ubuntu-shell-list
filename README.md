# Termux에 Ubuntu 설치하기

Termux! 특별과정!
환영합니다.
이 파일을 읽으면 여러분들도 
스마트폰에 리눅스 서버 구축 할 수 있게 됩니다.

Termux는 휴대폰으로 아래 URL로 접속한 다음,
화면을 내리면 APK로 내려 받는 게 있습니다. 
원하는 버전을 설치하세요.

https://f-droid.org/packages/com.termux/
https://f-droid.org/packages/com.termux/


아래 주의사항을 꼭 읽어주세요

## 첬 번째, 시스템 포트(0~1023)는 사용할 수 없습니다.
보안 정책으로 인해 시스템 포트 사용이 불가합니다.
대신, 시스템 포트를 사용하는 것들은 별도 포트 설정이 필요합니다
가령 SSH는 22번인데 3022로 바꾼다던가
apache나 nginx는 80번인데 8080으로 바꾼다던가 등의 작업을 하세요.

## 두 번째, Root 권한이 잠겨 있습니다.
마찬가지로 보안 정책으로 인해 일부 명령어를 사용할 수 없습니다.

[systemctl, ufw]와 같은 root 권한의 명령어 사용 불가합니다.
이는 어떠한 방법으로도 사용 불가하니 참고하세요.


## 세 번째, Root 권한이 필요한 서비스 설치도 불가합니다.
대표 예시로 Anaconda3가 있습니다.
설치 과정에서 문제가 발생하고 .conda 설정이 불가합니다.
이 점 참고바랍니다.

## 네 번째, 공기계 쓰세요.
번호가 등록된 자기 폰을 쓰는 미친놈은 없겠죠?
"먹통이 돼도 전혀 상관 없는 공기계"를 쓰십쇼


## 다섯 번째,블루투스 키보드를 활용하세요.
휴대폰에 블루투스 키보드를 연결하거나 USB포트로 키보드를 연결하세요.
엄지로 명령어 타이핑 칠 겁니까?
누가 찐따같이 그렇게 합니까?



# 설치 진행하기
각 파일들이 있을 겁니다 파일들 순차적으로 확인해보겠습니다.


## init.sh
termux를 휴대폰에 깔았다면 가장 먼저 해야 하는 작업입니다.
안 그럼 ubuntu 설치 못 합니다.
```
apt update
apt upgrade -y
apt install -y proot
apt install -y proot-distro
```


## ubuntu_login.sh
이제 우분투를 설치하고 우분투에 로그인할 겁니다.
CLI입니다. Desktop을 기대했다면 당장 나가세요.
```
proot-distro install ubuntu
proot-distro login ubuntu
```


## ubuntu_init.sh
root로 로그인 됐을 겁니다.
다시 초기 세팅 하십시오.
```
apt update
apt upgrade -y
```


편집기가 없습니다.
이제 편집기를 설치합시다.
```
apt install vim
```

설치 과정에서 시간대 설정하는 게 나옵니다.
지역과 국가에 알맞는 번호를 입력하세요.

국가는 항목이 너무 많아 안 보이는 게 있습니다.
Enter를 한 번 더 치면 모두 볼 수 있습니다.


## ubuntu_ssh_setting.sh
계속 휴대폰으로 작업할 수 없는 노릇입니다.
때문에, 원격 접속 허용을 위해 ssh 설치할 겁니다.
사용자 root 권한을 얻기위해 sudo 설치할 겁니다.
```
apt install -y openssh-server
apt install -y sudo
```



## 사용자계정 생성
```
adduser ubuntu
```

사용자 이름은 자유롭게 정하세요.
여기서는 ubuntu라 하겠습니다.
비밀번호 대충 "1234", "0000" 같은 거 입력하세요. 
짜피 아무도 안 봅니다.

아직 ubuntu로 로그인 하지 마세요.



## sudo 권한 부여
이제 만든 계정에 권한 줘야 합니다.
아까 vim 설치했죠? 그거 쓸 차례입니다.
```
vim /etc/sudoers
```

아래로 내리다보면 이런 문구가 보일 겁니다.
```
root    ALL=(ALL:ALL) ALL
ubuntu  ALL=(ALL:ALL) ALL #추가해야 할 거
```

root 계정 바로 아래에 사용자 계정 추가하고
저장하세요. 명령어는 다들 알죠?
ESC 누르고 :wq 

추가로, 블루투스 키보드는 ESC 누르면 나가집니다.
"fn + ESC" 쓰세요


## ssh 권한 설정
이제 sudo 권한 줬으니
ssh 권한 줄 차례입니다.
```
su ubuntu
```


ssh 설정 폴더로 가서 해당 파일을 열어 작업합니다.
```
sudo vim /etc/ssh/sshd_config
```

### Port 설정
아래로 내리다 보면 Port 정보가 있습니다.
```
Port 22
```

아까 위에서 시스템 포트 못 쓴다 했죠?
그래서 바꿔줄 겁니다.
여기서는 3022로 바꾸겠습니다.
```
Port 3022
```

나가지 마세요.
아직 안 끝났으니까.


### PasswordAUthentication 주석 제거
또 계속 아래로 내립니다.
```
...
PasswordAuthentication yes
...
```

저거 주석 돼 있을 겁니다. 주석 지웁니다.
그리고 저장하세요.


## ssh 서비스 시작
```
sudo service ssh start
# Starting OpenBSD Secure Shell server sshd [ OK ]
```

주석에 표시된 문구가 나와야 됩니다.
안 나오면 중간에 뭐 빼먹은 거 있다는 뜻입니다.


## 포트포워딩
마지막으로 포트포워딩 하세요.
이건 쓰는 공유기 맞춰 적용하십시오.