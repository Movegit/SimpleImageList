# SimpleImageList

SimpleImageList는 이미지 목록을 표시하고 상세 정보를 제공하는 iOS 애플리케이션입니다. 클린 아키텍처 패턴을 기반으로 구현되었으며, 모던 Swift 개발 방식을 따릅니다.

## 주요 기능

- 이미지 목록 표시
- 이미지 상세 정보 보기
- API를 통한 이미지 데이터 로드

## 기술 스택

- Swift
- UIKit
- SwiftLint (코드 스타일 및 규칙 검사)
- SnapKit (UI 레이아웃)
- Kingfisher (이미지 로딩 및 캐싱)
- Quick (BDD 스타일 테스트 프레임워크)
- Nimble (테스트를 위한 매처 프레임워크)

## 프로젝트 구조

프로젝트는 클린 아키텍처 패턴을 따르며 다음과 같은 구조로 구성되어 있습니다:

```
SimpleImageList/
├── API/                  # 네트워크 및 API 관련 코드
├── Domain/               # 비즈니스 로직 및 모델
├── Presentation/         # UI 및 화면 표시 로직
├── Util/Extensions/      # 유틸리티 및 확장 기능
├── Assets.xcassets/      # 이미지 및 앱 아이콘
├── ColorAssets.xcassets/ # 색상 에셋
└── Base.lproj/           # 기본 리소스 파일
```

## 요구 사항

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## 설치 방법

1. 저장소를 클론합니다:
```bash
git clone https://github.com/Movegit/SimpleImageList.git
```

2. Xcode에서 프로젝트를 엽니다:
```bash
cd SimpleImageList
open SimpleImageList.xcodeproj
```

3. 필요한 패키지가 자동으로 설치됩니다. 설치가 완료되면 앱을 빌드하고 실행할 수 있습니다.

## 테스트

프로젝트에는 다음과 같은 테스트가 포함되어 있습니다:

- 단위 테스트 (SimpleImageListTests)
- UI 테스트 (SimpleImageListUITests)
- DetailVC 테스트

이 프로젝트는 BDD(Behavior-Driven Development) 스타일의 테스트를 위해 Quick과 Nimble 프레임워크를 사용합니다:
- **Quick**: BDD 스타일의 테스트 구조를 제공하여 가독성 높은 테스트 코드 작성
- **Nimble**: 직관적인 매처(matcher)를 사용하여 테스트 결과 검증

### Testing
Run tests using:
```bash
xcodebuild test -project SimpleImageList/SimpleImageList.xcodeproj -scheme SimpleImageList -destination "platform=iOS Simulator,name=iPhone 15 Pro"
```

## CI/CD
This project uses GitHub Actions for continuous integration. The following checks are performed on each PR and push to main:
- SwiftLint code style check
- Build validation
- Unit tests
- UI tests
  
## 코드 스타일

이 프로젝트는 SwiftLint를 사용하여 코드 스타일과 규칙을 검사합니다. 설정은 `.swiftlint.yml` 파일에 정의되어 있습니다.

## 기여 방법

1. 이 저장소를 포크합니다.
2. 새로운 기능 브랜치를 생성합니다 (`git checkout -b feature/amazing-feature`).
3. 변경 사항을 커밋합니다 (`git commit -m 'Add some amazing feature'`).
4. 브랜치에 푸시합니다 (`git push origin feature/amazing-feature`).
5. Pull Request를 생성합니다.

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 연락처

프로젝트 관리자: [Movegit](https://github.com/Movegit)
