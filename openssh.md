## opsnssh 관련 설명
```
whoami
```
이걸로 계정 이름 확인하세요.<br>
지웠다 새로 깔 때마다 항상 임의로 부여됩니다.<br>
일반적으로는 u0_axxx 형태입니다.<br><br>
그다음 패스워드 적용하세요.
```
passwd
```
<br><br>

## ssh 실행하기
```
sshd
sv-enable sshd
sv up sshd
```
termux에서 ssh는 8022번입니다.<br>
이유는 README에서 설명했습니다.<br>

ssh가 실행됐으면 이제 접속 가능합니다.
```
ssh username@hostip -p 8022
# username과 hostip는 해당하는걸로 바꾸세요.
```

<br><br>
마지막으로 인터넷에서 파일을 내려받을 때 필요한 패키지와 편집기를 설치합니다.
```
pkg install vim wget curl -y
```

## 주의사항
- 휴대폰이 와이파이에 연결 돼 있어야 합니다.
- 일반적으로 와이파이는 내부 접속이 모두 됩니다. <br> 하지만 안되는 경우도 있으니, 꼭 찾아보세요