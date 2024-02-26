# KeyGo: 키워드로 회고하자

<img src="https://user-images.githubusercontent.com/81340603/204945336-287ce115-ac38-409f-8136-039ae4d5e140.png" />

<br>

<br>

## 🔑 Overview

- 프로젝트 소개
    - 상황을 키워드와 함께 기록하며, 회고 당일 피드백을 잊지 않고 전할 수 있습니다<br>
    - 팀 내에서 등록된 키워드를 확인하며, 예정된 회고 내용을 미리 볼 수 있습니다<br>
    - 회고 당일, 내가 받은 키워드를 확인하고 상세 상황을 들어보며 피드백을 나눌 수 있습니다<br>
    - 지금까지 내가 받은 피드백을 모아볼 수 있습니다<br>

- 기간: 
    - 1st Release: 2022.10 ~ 2023.02
    - 2nd Release: 2023.10 ~ 2023.12 (잠정 중단)
- 역할:
    - iOS Developer
    - Lead Designer
- [App Store Link](https://apps.apple.com/kr/app/%ED%82%A4%EA%B3%A0-keygo/id6444039454?l=en)

<br>

<br>

## ✏️ Main Contributions

### 이미지 로딩에 소요되는 시간을 줄이기 위한 ImageCacheManager 구현

<img src="https://github.com/seongmin221/KeyGo/assets/72431640/1672c72e-272e-4cc4-851c-843dde59b6fd" width="300">

- UICollectionViewCell에 프로필 이미지를 불러오는 과정 중 이미지 렌더링에 필요 이상의 메모리가 소모되는 문제점을 파악했습니다.
- 이를 해결하기 위한 방법으로 `이미지 다운샘플링`과 `이미지 캐싱` 중 더 빠르게 구현 가능한 `이미지 캐싱`을 사용했습니다.
- 캐싱을 위한 공간으로는, `Memory Cache`와 `Disk Cache` 중 많은 양의 이미지가 캐시에 저장되지 않기 때문에 `Memory Cache`를 사용했습니다. 

```swift
class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
```
```swift
extension UIImageView {
    func load(from url: String) {
        
        let cacheKey = NSString(string: url)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let imageUrl = URL(string: url),
               let data = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                        self?.image = image
                    }
                }
            }
        }
    }
}
```
- `Singleton Pattern`을 사용하여 `ImageCacheManager`로 관리하였습니다.
- `UIImageView`에서 이미지를 로드하는 과정에서, `ImageCacheManager`에 로드하고자 하는 이미지의 url이 포함되어 있다면, cache에서 해당 이미지를 가져옵니다.
- 만약 이미지 url이 포함되어 있지 않다면, cache에 이미지를 저장합니다.



<br>

<br>


### 좌측정렬 & UICollectionView Cell 동적 너비 레이아웃 커스텀 - 1st Release

<img src="https://github.com/seongmin221/KeyGo/assets/72431640/eb73e980-2d97-49a2-9420-6e1d8bb9c6c7" width=200></img>&nbsp;&nbsp;
<img src="https://github.com/seongmin221/KeyGo/assets/72431640/b2fffa91-c234-4bcb-a89b-74b86e2cf857" width=200></img>&nbsp;&nbsp;
<img src="https://github.com/seongmin221/KeyGo/assets/72431640/c4a789d1-d2ed-462e-aac0-3d400c22b5c7" width=200></img>

- `UICollectionViewFlowLayout`을 상속받아 `layoutAttributesForElements(in:)` 메소드를 override 하여 각 cell들이 좌측 정렬되도록 `layoutAttribute` 값을 조절했습니다.

```swift
final class KeywordCollectionViewFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = SizeLiteral.keywordLabelXSpacing
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = SizeLiteral.keywordLabelRowSpacing
        self.sectionInset = UIEdgeInsets(top: 15, left: SizeLiteral.leadingTrailingPadding, bottom: 0, right: SizeLiteral.leadingTrailingPadding)
        let attributes = super.layoutAttributesForElements(in: rect)
    
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
```
- 현재 Cell들의 최대 y좌표를 기록하여, 다음 Cell의 y좌표가 기존의 최대 y좌표보다 커지면, 시작 위치를 처음 위치로 조절합니다.
- 다음 Cell의 y좌표가 최대 y좌표보다 작다면, 자기 자신의 너비와 Cell 간 spacing만큼 x좌표를 추가합니다.



<br>



- `collectionView(layout:sizeForItemAt:)` 메소드에서 셀에 들어가는 키워드의 너비에 따라 너비 값을 다시 계산하는 과정을 진행해 동적 너비를 설정했습니다.
    
```swift
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    // ...
    
    if sectionIsEmpty && isUserRetrospective {
        return CGSize(width: view.frame.width - 2 * SizeLiteral.leadingTrailingPadding, 
                      height: Size.myReflectionEmptyViewHeight)
    } else if sectionIsEmpty && !isUserRetrospective {
        return CGSize(width: view.frame.width - 2 * SizeLiteral.leadingTrailingPadding, 
                      height: Size.othersReflectionEmptyViewHeight)
    }
    
    return KeywordCollectionViewCell.fittingSize(
        availableHeight: Size.keywordLabelHeight,
        keyword: keywordsSectionList[section][item].keyword
    )
}
```

```swift
static func fittingSize(availableHeight: CGFloat, keyword: String?) -> CGSize {
    let cell = KeywordCollectionViewCell()
    cell.configLabelText(keyword: keyword)
    let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
    return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
}
```
- 너비를 계산해야 하는 Cell의 dummy를 만들어 동일한 키워드로 설정하여 dummy의 크기를 계산했습니다.

<br>

<br>


### 좌측정렬 & UICollectionView Cell 동적 너비 레이아웃 Compositional Layout으로 리팩토링 - 2nd Release

```swift
func keywordCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { f, _ in
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .absolute(50)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 15, leading: 24, bottom: 36, trailing: 24)
        section.boundarySupplementaryItems = [createHeader()]

        return section
    }
}
```
- 기존 레이아웃 방식의 `fittingSize(availableHeight: CGFloat, keyword: String?) -> CGSize` 메소드에서 내부에 `KeywordCollectionViewCell`을 선언해 너비 계산 과정에서 불필요한 인스턴스 생성에서 리팩토링의 필요성을 느꼈습니다.
- 더욱 쉽게 레이아웃을 잡기 위해 `Compositional Layout`을 사용했습니다.




<br>


<br>

## 💡 Things I Learned

### 바인딩 시점과 Observable의 이해 [🔗 Discussion](https://github.com/seongmin221/What-Did-I-Learn.../discussions/5)

- 2차 릴리즈 준비 과정에 RxSwift를 공부하며 ViewController의 생명주기를 `rx.methodInvoked(_:)`로 관리하기 위해 준비하던 중, `viewDidLoad`에 대한 이벤트가 전달되지 않는 것을 파악했습니다.

- 디버깅 과정 중, ViewController와 ViewModel의 바인딩 시점에서 문제점을 파악했습니다.
    - ViewController와 ViewModel의 바인딩이 `viewDidLoad`에서 이루어졌고, `methodInvoked(_:)`는 `viewDidLoad`가 끝나고 난 뒤 이벤트를 전달함을 알게 되었습니다.

- 이 과정에서, RxSwift의 Observable에 대해 더 깊게 이해하였고, Hot Observable과 Cold Observable의 차이점에 대해 알게 되었습니다.


<br>

<br>


## 🔩 Tech & Skills

<img src="https://img.shields.io/badge/UIKit-blue" height="30"> <img src="https://img.shields.io/badge/Alamofire-blue" height="30"> <img src="https://img.shields.io/badge/SnapKit-blue" height="30"> <br>
<img src="https://img.shields.io/badge/Figma-red" height="30"> <br>
<img src="https://img.shields.io/badge/Github-yellow" height="30"> <img src="https://img.shields.io/badge/Miro-yellow" height="30"> <img src="https://img.shields.io/badge/Notion-yellow" height="30"> <img src="https://img.shields.io/badge/Slack-yellow" height="30">


<br>

<br>


## 🛠 Development Environment

<img src="https://img.shields.io/badge/iOS-14+-silver"> <img src="https://img.shields.io/badge/Xcode-14.0-blue">


<br>

<br>

## 👨‍🎨 Authors

|[Chemi / 최민관](https://github.com/MMMIIIN)|[Ginger / 김유나](https://github.com/Guel-git)|[Hoya / 이성호](https://github.com/dangsal)|[Id / 이성민](https://github.com/seongmin221)|[Mary / 김휘원](https://github.com/hwiwonK)|
|:---:|:---:|:---:|:---:|:---:|
| <img width=200px src="https://github.com/MMMIIIN.png"/> | <img width=200px src="https://github.com/Guel-git.png"/> | <img width=200px src="https://github.com/dangsal.png"/> | <img width=200px src="https://github.com/seongmin221.png"/> | <img width=200px src="https://github.com/hwiwonK.png"/> | 
|<center>iOS Lead Developer</center>|<center>Project Manager<br>iOS Developer<br>UI/UX Designer</center>|<center>iOS Developer<br>Team Manager</center>|<center>iOS Developer<br>UI/UX Lead Designer</center>|<center>Backend Developer<br>UI/UX Designer</center>|
