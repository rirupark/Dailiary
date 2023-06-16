# Dailiary 🌿
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=Firebase&logoColor=black)

<br>

## 📝 개요
일기장 서비스를 제공하는 나만의 데일리 다이어리 ʕo•ᴥ•ʔ✎

<br>

## ⚙️ 기능
- 다이어리 목록
- 다이어리 작성 및 삭제
- 위치 정보 남기기
- 사진 남기기
- 마이페이지

<br>

## 🗂️ 폴더링
<details>
<summary> Dailiary 파일 구조 보기 🔎 </summary>
<div markdown="1">       

```
 📦 Dailiary
 ┃
 ┣ 📂 Modifier
 ┃ ┗ 📜 Modifiers.swift 
 ┃ 
 ┣ 📂 Assets.xcassets
 ┃ ┣ 📂 AccentColor.colorset
 ┃ ┃ ┗ 📜 Contents.json
 ┃ ┣ 📂 AppIcon.appiconset
 ┃ ┃ ┗ 📜 Contents.json
 ┃ ┣ 📂 LightGray.colorset
 ┃ ┃ ┗ 📜 Contents.json
 ┃ ┗ 📜 Contents.json
 ┃
 ┣ 📂 Model
 ┃ ┣ 📜 DiaryInfo.swift
 ┃ ┗ 📜 UserInfo.swift
 ┃
 ┣ 📂 View
 ┃ ┣ 📂 Auth
 ┃ ┃ ┣ 📜 LogInView.swift
 ┃ ┃ ┣ 📜 SignUpEmailView.swift
 ┃ ┃ ┣ 📜 SignUpNicknameView.swift
 ┃ ┃ ┣ 📜 SignUpTermSafariView.swift
 ┃ ┃ ┣ 📜 SignUpTermType.swift
 ┃ ┃ ┗ 📜 SignUpTermsView.swift
 ┃ ┃
 ┃ ┣ 📂 Home
 ┃ ┃ ┣ 📜 AddDiaryView.swift
 ┃ ┃ ┣ 📜 DetailDiaryView.swift
 ┃ ┃ ┗ 📜 HomeView.swift
 ┃ ┃
 ┃ ┣ 📂 Map
 ┃ ┃ ┣ 📜 MapView.swift
 ┃ ┃ ┗ 📜 SearchAddressView.swift
 ┃ ┃
 ┃ ┗ 📂 Mypage
 ┃   ┗ 📜 MypageView.swift
 ┃
 ┣ 📂 ViewModel
 ┃ ┣ 📜 AuthViewModel.swift
 ┃ ┣ 📜 DiaryViewModel.swift
 ┃ ┗ 📜 LocationManager.swift
 ┃ 
 ┣ 📂 Preview Content
 ┃ ┗ 📂 Preview Assets.xcassets
 ┃   ┗ 📜 Contents.json
 ┃ 
 ┣ 📜 ContentView.swift
 ┣ 📜 DailiaryApp.swift
 ┗ 📜 GoogleService-Info.plist
```

</div>
</details>

<br>

## 📱 실행 화면
|로그인|회원가입 (이메일, 비밀번호)|회원가입 (닉네임)
|:-:|:-:|:-:|
|<img src="https://github.com/rirupark/Dailiary/assets/82339184/007a3645-e401-4d0d-a2c0-f43a163bb12a" width="100%">|<img src="https://github.com/rirupark/Dailiary/assets/82339184/3825c11e-ed7b-43a0-b97c-2ca99c6872a3">|<img src="https://github.com/rirupark/Dailiary/assets/82339184/ef8b6409-3436-47fc-b3c6-6f3a6b6ebbdd" width="100%">|

|홈|다이어리 추가|이미지 추가|
|:-:|:-:|:-:|
|<img src="https://github.com/rirupark/Dailiary/assets/82339184/4984eda1-b86d-4ee9-801d-ce8a92245a0a" width="100%">|<img src="https://github.com/rirupark/Dailiary/assets/82339184/9b27af34-ee31-462d-807c-b74641cb46ab">|<img src="https://github.com/rirupark/Dailiary/assets/82339184/a856ba7d-394f-40fb-8242-dff1de305e3e" width="100%">|

|위치 검색|위치 추가|작성한 다이어리 확인|
|:-:|:-:|:-:|
|<img src="https://github.com/rirupark/Dailiary/assets/82339184/c6ab81fe-f7d2-4f1b-98ae-7a73e34c52d0" width="100%">|<img src="https://github.com/rirupark/Dailiary/assets/82339184/cbb36a4f-fc1c-4311-beff-3dcd4cad9b81" width="100%">|<img src="https://github.com/rirupark/Dailiary/assets/82339184/f042219c-466a-4b38-afd5-61703b80a2ff">|
