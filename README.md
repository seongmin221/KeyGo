# KeyGo: 키워드로 회고하자

<img src="https://user-images.githubusercontent.com/81340603/204945336-287ce115-ac38-409f-8136-039ae4d5e140.png" />



## Overview

- 기간: 
    - 1st Release: 2022.10 ~ 2023.02
    - 2nd Release: 2023.10 ~ 2023.12 (잠정 중단)
- 역할:
    - iOS Developer
    - Lead Designer
- [App Store Link](https://apps.apple.com/kr/app/%ED%82%A4%EA%B3%A0-keygo/id6444039454?l=en)



<br>

## Things I Learned

### 

<br>

## Main Contributions

### 좌측정렬 & UICollectionView Cell 동적 너비 레이아웃 커스텀 - 1st Release

<img src="https://github.com/seongmin221/KeyGo/assets/72431640/eb73e980-2d97-49a2-9420-6e1d8bb9c6c7" width=200></img>&nbsp;&nbsp;
<img src="https://github.com/seongmin221/KeyGo/assets/72431640/b2fffa91-c234-4bcb-a89b-74b86e2cf857" width=200></img>&nbsp;&nbsp;
<img src="https://github.com/seongmin221/KeyGo/assets/72431640/c4a789d1-d2ed-462e-aac0-3d400c22b5c7" width=200></img>

`UICollectionViewFlowLayout`을 상속받아 `layoutAttributesForElements(in:)` 메소드를 override 하여 각 cell들이 좌측 정렬되도록 `layoutAttribute` 값을 조절했습니다.

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

<br>



`collectionView(layout:sizeForItemAt:)` 메소드에서 셀에 들어가는 키워드의 너비에 따라 너비 값을 다시 계산하는 과정을 진행해 동적 너비를 설정했습니다.
    
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

## 프로젝트 소개

- 상황을 키워드와 함께 기록하며, 회고 당일 피드백을 잊지 않고 전할 수 있습니다<br>
- 팀 내에서 등록된 키워드를 확인하며, 예정된 회고 내용을 미리 볼 수 있습니다<br>
- 회고 당일, 내가 받은 키워드를 확인하고 상세 상황을 들어보며 피드백을 나눌 수 있습니다<br>
- 지금까지 내가 받은 피드백을 모아볼 수 있습니다<br>

<br>




















<img src="https://user-images.githubusercontent.com/81340603/204945336-287ce115-ac38-409f-8136-039ae4d5e140.png" />
<h3 align="center">키고: KeyGo</h3>
<p align="center">KeyGo를 통해 솔직하고 재미있는 팀 회고 시간을 가져 보아요!</p>

<div style="display: flex; flex-direction: column;" align="center" >
  <a href="https://apps.apple.com/kr/app/%ED%82%A4%EA%B3%A0-keygo/id6444039454?l=en">
    <img src="https://user-images.githubusercontent.com/81340603/204947353-18c33fe9-c49b-443a-b1e2-7cf9a85bb91b.png" width=180px />
  </a>
  <p3>&nbsp;&nbsp;&nbsp;</p3>
  <a href="https://github.com/hwiwonK/MacC-Team-Maddori.Apple-Server">
    <img src="https://user-images.githubusercontent.com/81340603/205491490-1ec07066-5b90-4277-9907-42b1ef47fe45.png" width=60px/>
  </a>
</div>


<h2>🧐 Preview</h2>
<img src="https://user-images.githubusercontent.com/81340603/204951310-45345674-3d00-4d72-a61b-bc6ddc996363.png" />

<div align="center">
  ➿<br>
  상황을 키워드와 함께 기록하며, 회고 당일 피드백을 잊지 않고 전할 수 있습니다<br>
  팀 내에서 등록된 키워드를 확인하며, 예정된 회고 내용을 미리 볼 수 있습니다<br>
  회고 당일, 내가 받은 키워드를 확인하고 상세 상황을 들어보며 피드백을 나눌 수 있습니다<br>
  지금까지 내가 받은 피드백을 모아볼 수 있습니다<br>
  ➿
</div>

<br>


<h2>🗂 Directory Structure</h2>
<img src="https://user-images.githubusercontent.com/81340603/204957214-2d19ce84-04d6-49c3-9c11-9984be7fd7d6.png" />


<br>


<h2>🔩 Tech & Skills</h2>

<img width="61" src="https://img.shields.io/badge/UIKit-blue"> <img width="103" src="https://img.shields.io/badge/Alamofire-blue"> <img width="87" src="https://img.shields.io/badge/SnapKit-blue"> <img width="118" src="https://img.shields.io/badge/AppleLogin-blue"> <br>
<img width="70" src="https://img.shields.io/badge/Figma-red"> <img width="75" src="https://img.shields.io/badge/Github-yellow"> <img width="53" src="https://img.shields.io/badge/Miro-yellow"> <img width="73" src="https://img.shields.io/badge/Notion-yellow"> <img width="64" src="https://img.shields.io/badge/Slack-yellow">


<br>


<h2>🛠 Development Environment</h2>

<img width="100" src="https://img.shields.io/badge/iOS-14+-silver"> <img width="125" src="https://img.shields.io/badge/Xcode-14.0-blue">


<br>


<h2>🔏 License</h2>
<img width="170" src="https://img.shields.io/badge/MIT License-2.0-yellow">


<br>

<h2>👨‍🎨 Authors</h2>

|[Chemi / 최민관](https://github.com/MMMIIIN)|[Ginger / 김유나](https://github.com/Guel-git)|[Hoya / 이성호](https://github.com/dangsal)|[Id / 이성민](https://github.com/seongmin221)|[Mary / 김휘원](https://github.com/hwiwonK)|
|:---:|:---:|:---:|:---:|:---:|
| <img width=200px src="https://github.com/MMMIIIN.png"/> | <img width=200px src="https://github.com/Guel-git.png"/> | <img width=200px src="https://github.com/dangsal.png"/> | <img width=200px src="https://github.com/seongmin221.png"/> | <img width=200px src="https://github.com/hwiwonK.png"/> | 
|<center>iOS Lead Developer</center>|<center>Project Manager<br>iOS Developer<br>UI/UX Designer</center>|<center>iOS Developer<br>Team Manager</center>|<center>iOS Developer<br>UI/UX Lead Designer</center>|<center>Backend Developer<br>UI/UX Designer</center>|
