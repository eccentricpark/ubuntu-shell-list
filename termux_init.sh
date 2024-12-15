# termux 들어왔으면 저장공간 허용부터
termux-setup-storage -y

# 패키지 업데이트 및 업그레이드
pkg update
pkg upgrade

# 저장소 설치하기
# 과정에서 버전 설치 언급이 있을 거임
# currently install version 이라는 뉘앙스로 적힌 항목을 선택하여 설치하면 됨
pkg install root-repo x11-repo -y
pkg upgrade