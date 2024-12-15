여기까지 왔다면 정말 잘 온겁니다.<br>
다시 가상머신을 실행해볼까요?<br>

## 도커 설치하기
```
apk search docker
apk add docker
```
<br><br>

## 도커 실행하기
```
addgroup root docker
rc-update add docker boot
service docker start
```

## 도커 명령어 테스트하기
```
docker ps
docker run hello-world
```
<br><br>

- 아래처럼 나오면 성공입니다.

```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
c1ec31eb5944: Pull complete
Digest: sha256:305243c734571da2d100c8c8b3c3167a098cab6049c9a5b066b6021a60fcb966
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```


## 이미지 확인해보기
```
docker images
```
방금 hello-world 내려받았으니까 당연히 있겠죠?





## 마지막 nginx 테스트하기
우리 무슨 포트 연결 허용해줄지 아직 안정했어요.<br>
이거 명령어때마다 추가해줘야되서 상당히 좆같습니다.<br>
그래도 어쩔 수 없죠. 우리는 10,000번 포트 쓸 거에요<br><br>

아마 가상머신 실행 돼 있을텐데요.<br> 
끄고 아래 명령어로 다시 가동합시다.

```
qemu-system-x86_64 -machine q35 -m 2048 -smp cpus=4 -cpu qemu64 \
-drive if=pflash,format=raw,read-only=on,file=$PREFIX/share/qemu/edk2-x86_64-code.fd \
-netdev user,id=n1,hostfwd=tcp::2222-:22,hostfwd=tcp::10000-:10000 \
-device virtio-net,netdev=n1 \
-nographic alpine.img
```

- 주의! 명령어 옵션 추가할 때 띄어쓰기 하지 마세요. 바로 반찬투정 부립니다.



## nginx 이미지 내려받기
```
docker pull nginx:latest
```

## 외부 10000번 포트와 도커 내부 80번 포트를 연결하기
```
docker run -d --name nginx_test -p 10000:80 nginx:latest
```

휴대폰에서 ifconfig 검색해서 내부 ip 확인하고<br>
해당 포트에 맞춰 접속하면 nginx 뜰 겁니다.<br><br>


## 축하합니다. nginx를 띄웠습니다.
이제 알아서 하세요.