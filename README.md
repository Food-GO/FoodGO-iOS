# 인공지능 유사도를 활용한 식재료 기반 음식 추천 AR 서비스 프로젝트


![](https://github.com/user-attachments/assets/e5570d54-a0d3-4341-bf8b-7a73eac62981)



## Demo
<p float="left">
    <img src="https://github.com/user-attachments/assets/f5267fef-3e23-4f12-9cef-582a942cec18" width=200 />
    <img src="https://github.com/user-attachments/assets/10d1bfdd-0d52-475a-93ae-f385c6aad9d5" width=200 />
    <img src="https://github.com/user-attachments/assets/8203e914-ab1e-489e-8132-015cd6e71152" width=200 />
    <img src="https://github.com/user-attachments/assets/83c4af7d-b299-46db-9ec5-57bf38b9806c" width=200 />
    <img src="https://github.com/user-attachments/assets/3e9132ee-0e79-41f5-b703-7cf97a3bbc17" width=200 />
    <img src="https://github.com/user-attachments/assets/5c1eacf7-0112-422c-861a-b002b3fca944" width=200 />
    <img src="https://github.com/user-attachments/assets/2f4a01ab-2fa4-46ec-83c2-694d38cc30a5" width=200 />
    <img src="https://github.com/user-attachments/assets/fd683e92-f599-42ff-beaf-dddfb2356c22" width=200 />
</p>

## ⭐ Main Feature
### 회원가입 및 로그인
- 회원가입
- 로그인

### 음식 추천
- 음식 취향 테스트
- 식재료 등록

### 홈
- 식재료 인식
- 식재료 영양정보 조회
- 식재료 리포트

## 🔧 Stack
- **Language**: Swift
- **Library & Framework** : Vision, Alamofire, Kingfisher, RxSwift, SnapKit, Then

## Project Structure
```markdown
├── App
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Base.lproj
│   ├── LaunchScreen.storyboard
│   └── Main.storyboard
├── Common
│   ├── AlertManager.swift
│   ├── LoadingIndicator.swift
│   └── UserDefaultsManager.swift
├── Info.plist
├── Network
│   ├── APIResponse.swift
│   ├── NetworkService.swift
│   └── OpenAPIResponseModel.swift
├── Presentation
│   ├── Community
│   ├── Home
│   ├── Login
│   ├── MyProfile
│   ├── Onboarding
│   ├── RecognizeAR
│   ├── RecommendFood
│   ├── Register
│   ├── RegisterFood
│   ├── Report
│   ├── TabBar
│   └── TasteTest
└── Resources
    ├── Assets.xcassets
    ├── DesignSystem
    ├── Extension
    ├── Fonts
    ├── Reusable
    ├── art.scnassets
    └── light_best.mlmodel
```

## 👨‍💻 Role & Contribution

**iOS**
- 기여도 100%

## 고민한 부분
- 식재료 실시간 인식 성능을 높이기 위해 AI 모델을 coreML로 넣어 온디바이스에서 식재료 인식 진행
- 공통 응답 모델 (APIResponse)를 만들고, 제네릭을 이용하여 응답 모델 재사용
- BaseViewController를 만들어 상속하여 중복된 코드를 최소화


## 🏅 Award
- 2024 한국정보처리학회 학술대회 우수상(한국정보처리학회장상)
- 2024 한이음 은상(정보통신기획평가원장상)