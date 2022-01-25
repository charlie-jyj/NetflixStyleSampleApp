## 넷플릭스 스타일 영화추천 앱 

### 1) 구현 기능
- 리스트 형태 화면 구현
- UICollectionView
    - UIStackView, UITableView의 한계를 넘어

### 2) 기본 개념

#### (1) UICollectionView

- 행과 열의 나열 뿐만 아니라 다양한 배열 표현
- 그리드, 스택, 원형 레이아웃, 동적 변경 레이아웃 등
- Data와 Layout의 엄격한 구분

https://developer.apple.com/documentation/uikit/uicollectionview

1. Top-level Containment and Management
최상위 컨트롤
    - UICollectionView
    - UICollectionViewController

    - 컬렉션 뷰가 보여지는 시각적인 요소 정의
    - UIScrollView 상속
    - Layout 객체의 정보를 기반으로 데이터 표시

2. Content Management
    1) *UICollectionViewDataSource* protocol
        - 필수 요소
        - Content 관리 및 Content 표시에 필요한 View 생성

    2) *UICollectionViewDelegate* protocol
        - 선택 요소
        - 특정 상황에서 View 동작 custom

3. Presentation
    - UICollectionViewReusableView
    - *UICollectionViewCell*
    - Header, Footer (Supplementary view)
    - 재사용 뷰

4. Layout
UITableView에는 없는 개념: 레이아웃 객체
    1) UICollectionviewFlowLayout
    2) UICollectionViewDelegateFlowLayout protocol

        - UIColectionViewLayout
        - UICollectionViewLayoutAttributes
        - UICollectionViewUpdateItem

        - 각 항목 배치 등 시각적 스타일 담당 (Reusable Cell의 위치, 크기, 시각적 속성 등)
        - View를 직접 소유하지 않는 대신, 속성 객체 Attributes 생성 : 이 속성을 실제 뷰에 적용하는 것은 UICollectionView
        - 데이터 항목 수정 시 UpdateItem 인스턴스 수신

=> 이러한 책임과 역할 분리를 통해 data를 변경하지 않고도 레이아웃을 동적으로 변경 가능

- Grid, line-based layout 구현
- 레이아웃 정보를 동적으로 custom

// Before you start building custom layouts 
Consider whether doing so is really necessary

- Boiler code
- performance 저하


#### (2) UICollectionViewCompositionalLayout
> iOS 13+, advanced collection layout

A layout object that lets you combine items in highly adaptive and flexible visual arrangements
A compositional layout is a type of collection view layout.
- composable
- flexible
- fast

Which is composed of one or more sections that break up the layout into distinct visual groupings.
Each Section is composed of groups of individual items, the smallest unit of data you want to present.

You combine the components by building up from items into a group, from groups into a section,
And finally into a full layout

```swift
func createBasicListLayout() -> UICollectionViewLayout { 
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),                                  
                                         heightDimension: .fractionalHeight(1.0))    
    let item = NSCollectionLayoutItem(layoutSize: itemSize)  
  
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),                                          
                                          heightDimension: .absolute(44))    
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,                                                   
                                                     subitems: [item])  
  
    let section = NSCollectionLayoutSection(group: group)    

    let layout = UICollectionViewCompositionalLayout(section: section)    
    return layout
}

```
Section 마다 레이아웃 스타일이 달라질 경우, 
스타일 마다 다른 각 함수로 나누어 위의 코드를 달리 작성하고 
분기 처리하여 반환한다.

<img src=“https://docs-assets.developer.apple.com/published/2308306163/rendered2x-1585241228.png”>

1. Item
개별 컨텐츠의 크기 공간 정렬 방법의 청사진
화면에 렌더링 되는 단일 view (supplementary view 포함)
너비, 높이 고유 사이즈 dimension을 가짐
상대적인 치수(dimension)를 절대 값으로 표현하거나
런타임 시에 변경될 수 있는 추정값 (시스템 폰트 크기에 따른)


NSCollectionLayoutDimension
https://developer.apple.com/documentation/uikit/nscollectionlayoutdimension
- Absolute
```swift
let absoluteSize = NSCollectionLayoutSize(widthDimension: .absolute(44),
                                         heightDimension: .absolute(44))


```
- Estimate
If the size of your content might change at runtime, such as when data is loaded or in response to a change in system form size.
You provide an initial estimated size and the system computes the actual value later
```swift
let estimatedSize = NSCollectionLayoutSize(widthDimension: .estimated(200),
                                          heightDimension: .estimated(100))


```
- Fractional
To define a value that’s relative to a dimension of the items’ container
This options simplifies specifying aspect ratios.
```swift
let fractionalSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                           heightDimension: .fractionalWidth(0.2))

```

2. Group
레이아웃 형태에 따라 그룹핑
컬렉션 레이아웃 아이템의 하위 클래스이기 때문에 item와 같은 방식으로 사이즈 결정할 수 있다.

A container for a set of items that lays out the items along a path.
https://developer.apple.com/documentation/uikit/nscollectionlayoutgroup

<img src=“https://docs-assets.developer.apple.com/published/da3f6c0455/rendered2x-1585241229.png”>

Each group specifies its own size in terms of a width dimension and a height dimension.
Groups can express their dimensions relative to their container as an absolute value, or as an estimated value that might change at runtime, like in response to a change in system font size.
Because a group is a subclass of NSCollectionLayoutItem, it behaves like an item.
You can combine a group with other items and groups into more complex layouts.

3. Section
A container that combines a set of groups into distinct visual groupings

A collection view layout has one or more sections. Sections provide a way to separate the layout into distinct pieces.
Each section can have the same layout of a different layout than the other sections in the collection view.
A sections’s layout is determined by the properties of the group (NSCollectionLayoutGroup) that’s used to create the section.

Each section can have its own background, header, and footer to distinguish it from other sections.

<img src=“https://docs-assets.developer.apple.com/published/50b94fa74b/rendered2x-1585241228.png”>


#### (3) SnapKit
오픈 소스 프레임워크

Xcode 로 화면을 그리는 3가지 방법
- Storyboard Interface Builder
- 코드로 작성
    - Auto Layout 을 코드로…? => SnapKit 사용
- Swift UI


### 3) 새롭게 배운 것

- Swift Package Manager

- 코드로만 화면을 그리기
    - 빌드했더니 에러가?
    info.plist 확인, Main storyboard 를 바라보고 있는 항목을 삭제한다.
    - 내가 만든 viewController를 Initial View Controller 로 만들기
    SceneDelegate: willConnectTo 
        - tells the delegate about the addition of a scene to the app
        - this method is called when you app creates or restores an instance of your user interface

```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let layout = UICollectionViewFlowLayout()
        let homeViewController = HomeViewController(collectionViewLayout: layout)
        let rootNavigationController = UINavigationController(rootViewController: homeViewController)
        
        self.window?.rootViewController = rootNavigationController
        self.window?.makeKeyAndVisible()
    }
```
- makeKeyAndVisible
    - to show the current window and position it in front of all other windows at the same level or lower.


- AppDelegate vs SceneDelegate
> ios13+
    - AppDelegate : Process Lifecycle + Session Lifecycle
    - SceneDelegate: UILifecycle

Your app delegate object manages your app’s shared behaviors.
The app delegate is effectively the root object of your app, and it works in conjunction with UIApplication to manage some interactions with the system.
Like the UIApplication object, UIKit creates your app delegate object early in your app’s launch cycle so it is always present

- Initializing your app’s central data structures
- Configuring your app’s scenes
- Responding to notifications originating from outside the app, such as low-memory warnings, download completion notifications, and more
- Responding to events that target the app itself, and aren’t specific to your app’s scenes, view, or view controllers
- Registering for any required services at launch time, such as Apple Push Notification service

https://developer.apple.com/documentation/uikit/uiapplicationdelegate

- image literal
Assets 에 추가한 이미지를 UIImage로 간단하게 사용

- enum
```swift
enum SectionType: String, Decodable {
        case basic
        case main
        case large
        case rank
    }

```
`case 가 String 타입이면 raw value 를 생략해도 된다.
.basic = “basic”

- plist 에서 데이터 읽어오기
```swift
 guard let path = Bundle.main.path(forResource: "Content", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let list = try? PropertyListDecoder().decode([Content].self, from: data) else { return []}
```

이전에 UserDefault에 데이터를 저장하고 불러올 때에 PropertyListDecoder(Encoder) 를 사용했었는데,
UserDefaults 자체가 내부적으로 plist 파일에 저장하기 때문이었다.
https://crystalminds.medium.com/where-are-the-standard-userdefaults-stored-d02bf74854ff

- UICollectionViewCell 
     - *contentView* 를 superview로 두고 이 위에 subview를 쌓아올린다
    - addSubviews
    - addSubviews 한 후에 constraint 추가 등

- UICollectionView 를 사용하여 화면 구성하기 프로세스 요약
1. CollectionViewController를 생성한다.
2. 해당 collectionViewController 의 collectionViewLayout을 설정한다 
    1) UICollectionViewFlowLayout
3. UICollectionViewCell 채택하는 class 를 만든다
    1) *override layoutSubviews*
    2) content view(super view) 의 Attribute 를 지정한다.
    3) Subviews 설정한다
4. Cell을 Collection view에 register 한다.
    1) forCellWithReuseIdentifier
5. SupplementaryView (Header, Footer) class 를 만든다
6. SupplementaryView를 collection view에 register 한다
    1) forSupplementaryViewOfkind
    2) elementKindSectionHeader, elementKindSectionFooter
7. Datasorce, Delegate(opt) 구현
    1) Datasource: 섹션 수, 섹션 당 셀의 수, 무슨 셀인지, 무슨 supplementary view 인지  (이미지, 값…)
    2) Custom한 클래스로 cell 과 supplementary view 의 옷을 입힌다 
8. Layout을 정한다.
    1) 레이아웃 스타일이 다른 Section 마다 함수 정의 : UICollectionViewCompositionalLayout 을 반환하는 함수
    2) UICollectionViewCompositionalLayout.init(section:)
    3) Header. Footer가 있을 경우, 따로 아이템 설정 : NSCollectionLayoutBoundarySupplementaryItem 을 반환하는 함수
    4) 위의 함수를 통해 반환된 supplementary view를  8-1 함수에 추가 설정
    

- Header 만들 때 type 이 반드시 UICollectionReusableView


- Swift UI 로 미리보기 하다가 navigation view의 bar item이 보이지 않는?
    - navigationController?.navigationItem !== navigationItem
    - navigation item is instance Property: the navigation item used to represent the view controller in a parent’s navigation bar
    - viewController 의 property 라는 점!
        - a unique instance of UINavigationItem created to represent the view controller when it is pushed onto a navigation controller
        - you can either override this property and add code to create the bar button items when first accessed or create the items in your view controllers’s initialization code

https://stackoverflow.com/questions/16913332/navigationcontroller-navigationitem-vs-navigationitem


- addArrangedSubview vs addSubview
The view to be added to the array of views arranged by the stack
뚜렷하게 차이를 모르겠지만 아래의 링크를 참고..
https://stackoverflow.com/questions/55221703/addarrangedsubview-vs-addsubview

- UILabel.sizeToFit
텍스트에 맞게 라벨의 크기가 조정된다.

