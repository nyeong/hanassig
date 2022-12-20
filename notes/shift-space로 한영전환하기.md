---
title: "shift-space로 한영전환하기"
---


언제부턴가 한/영 전환에 shift-space가 설정 안 되게 바뀌었다. 아래의 방법으로 강제로 가능하다.

1.  시스템 설의 키보드 > 단축키 > 이전 입력 소스를 더클클릭하고 아무 키나 입력한다. 수정하지 않으면 plist 에 수정할 값이 보이지 않기 때문이다.
2. [PlistEdit](https://www.fatcatsoftware.com/plisteditpro/PlistEditPro.zip) 를 다운로드해서 설치 한다. Xcode 가 설치되어 있으면 Xcode 로 열 수 있다.
    
3.  파인더에서 사용자 폴더 아래의 라이브러리 폴더를 연다. 라이브러리 폴더는 숨김 처리되어 있다. 파인더 메뉴바의 ‘이동 메뉴’를 Option 키를 누른 상태에서 클릭하면 ‘라이브러리’ 폴더가 표시된다.
    
4.  라이브러리 풀더 아래 Preferences 안에서 다음 plist 파일을 PlistEdit Pro 로 연다./Users/<사용자>/Library/Preferences/com.apple.symbolichotkeys.plist
    
5.  Property List 에서 60을 찾는다. 맨 아래에 있을 것이다.
    
6.  `60/value/parameters/2`를 `131072`로 바꿔준다. ![](assets/image.png)
7. 이후 재부팅하면 적용된다.