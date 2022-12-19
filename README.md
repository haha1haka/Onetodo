<img width="999" alt="스크린샷 2022-12-13 14 08 23" src="https://user-images.githubusercontent.com/106936018/207231624-940b02b4-bcda-47b3-8525-acd492111cd4.png">

> Appstore: [https://apps.apple.com/kr/app/onetodo-%ED%88%AC%EB%91%90/id1645004556](https://apps.apple.com/kr/app/onetodo-%ED%88%AC%EB%91%90/id1645004556)



<br/><br/>



## Onetodo

> *개발기간: 2022.09.08 ~ 2022.09.28*

* 주차에 할일을 가볍게 적을수 있는 todo 앱 입니다.
* 오늘 할일만 빠르게 확인 해보실 수 있습니다.
* 색상별로 할일에 카테고리를 나눠 투두를 작성 할수 있습니다.
* 애플의 UI/UX 를 사랑합니다. 애플기본앱(UI/UX)을 많이 참고하여, 이질감 없는 앱을 경험 하실수 있습니다.
<br/><br/>



## Table Of Contents

* [TechStack](https://github.com/haha1haka/todotodo#tech-stack)

* [Tech Posting](https://github.com/haha1haka/todotodo#table-of-apples-api-and--patterns)
* [Application architecture](https://github.com/haha1haka/todotodo#application-architecture)
* [Simulation](https://github.com/haha1haka/todotodo#simulation)
* [회고](https://github.com/haha1haka/todotodo#%ED%9A%8C%EA%B3%A0)
* [Updating](https://github.com/haha1haka/todotodo#progressing%ED%96%A5%ED%9B%84-update-%EC%98%88%EC%A0%95)



<br/><br/>

## Tech Stack

* MVC
* Swift5.7
* UIKit
* Snapkit
* RelamDatabase
* Firebase Analytics, Crashlytics
* Firebase RemoteNotification

<br/><br/>

## Used Tech Posting

* [UICollectionViewDiffableDataSource](https://github.com/haha1haka/iOS-Topics/issues/3)
* [UICollectionViewCompositionalLayout](https://github.com/haha1haka/iOS-Topics/issues/1)
* [NSMutableAttributedString](https://github.com/haha1haka/iOS-Topics/issues/22)
* [UIColorPicker](https://github.com/haha1haka/iOS-Topics/issues/25)
* [UIDatePicker](https://github.com/haha1haka/iOS-Topics/issues/24)
* [UIPageViewController](https://github.com/haha1haka/iOS-Topics/issues/23)
* [Firebase Analytics, Crashlytics](https://github.com/haha1haka/iOS-Topics/issues/15)
* [Firebase Remote Notification(FCM)](https://github.com/haha1haka/iOS-Topics/issues/31)
* [SingletonPattern](https://github.com/haha1haka/iOS-Topics/issues/30)
* [RepositoryPattern](https://github.com/haha1haka/iOS-Topics/issues/20)
* UISheetPresentationController(update..)

<br/><br/>



## Application architecture

<br/>

<img width="1044" alt="스크린샷 2022-12-13 14 07 09" src="https://user-images.githubusercontent.com/106936018/207231464-1bcd605e-96b7-48a4-b731-fd357086e570.png">

MVC 패턴을 활용 하였습니다. view로 부터 UserAction이 발생하면 controller 에서 Model 이 변경 되고

Model 이 변경이 완료 되면 controller 를 통해 변경된 model 을 다시 View를 통해 사용자 에게 보여지게 합니다.

<br/><br/>

## Simulation

### 1. Add Todo

![AddTodo](https://user-images.githubusercontent.com/106936018/206976818-67d365d3-100c-4e40-bf50-f089f28b52bc.gif)

Add 버튼 을 통해 todo 입력 화면으로 이동합니다.

할일을 적고 날짜, 중요도, Lable and Background color 를 지정 해서 todo 를 추가해 줍니다.

DatePicker 를 UISheetPresentation 에 태워서 user 가 손쉽게 date 를 설정 하도록 합니다.

<br/>



> ❌Error Handling: 디바이스 크기가 작을수록 datePicker 짤리는 문제 
>
> ✅ datePicker 를 scrollView에 한번 더 태워서 디바이스가 작아 짤리는 부분은 scroll 할 수 있게끔 구현

<br/>

### 2. Delete and Edit Todo

![Delete and Edit Todo](https://user-images.githubusercontent.com/106936018/206977655-b9ba0754-8978-461d-85c5-6a8815b7712a.gif)

UIContextMenuConfiguration 이용 하여 UIMenu 를 구성 하여 주었습니다.

UICollectionViewdelegate method인 **contextMenuConfigurationForItemAt**를 통해 selectedItem 을 구성하고

selectedItem의 snapshot(UI) 과 realm Repository 의 data 를 함께 지워 주고 datasource 를 다시 그려 줍니다. 

<br/><br/>

### 3. Search and Complete Todo

![Search and Complete Todo](https://user-images.githubusercontent.com/106936018/206978547-6e3186c8-f92c-4d86-9fcb-54b46a7217bf.gif)

NSAttributedString를 이용하여 completed todo 를 구별 하여 줍니다.

> 🔥post: [https://github.com/haha1haka/iOS-Topics/issues/22](https://github.com/haha1haka/iOS-Topics/issues/22)

<br/>



filtering 을 통해서 searchBar 에 입력한 todo들만 item 으로 구성하여 snapshot 을 apply 합니다

```swift
		if self.isSearchControllerFiltering || searchController.isActive {
        var newSnapShot = NSDiffableDataSourceSnapshot<SearchSection, ToDo>()
        newSnapShot.appendSections([.main])
        newSnapShot.appendItems(repository.fetch().filter { element in
            let content = element.title
            return content.localizedStandardContains(text)
        })
        collectionViewDataSource.apply(newSnapShot, animatingDifferences: true)
    }
```





<br/>

### 4. checkToday with Pandel 



![checkToday](https://user-images.githubusercontent.com/106936018/206978919-aeaa018e-1938-424d-a3f7-37added708cc.gif)



Panel 이 fullScreen 일때, 내가 설정한 priority(우선순위)를 통해  section 과 item 들을 다르게 구성

```swift
    func fullScreenSnapShot() {

        var snapshot = collectionViewDataSource.snapshot()
      
        for item in collectionViewDataSource.snapshot(for: "오늘 확인").items {
            
            snapshot.deleteItems([item])
            
            if snapshot.itemIdentifiers(inSection: "오늘 확인").isEmpty {
                snapshot.deleteSections(["오늘 확인"])
            }
            
            if item.priority {
                if !snapshot.sectionIdentifiers.contains("중요 todo") {
                    snapshot.appendSections(["중요 todo"])
                }
                snapshot.appendItems([item], toSection: "중요 todo")
            } else {
                if !snapshot.sectionIdentifiers.contains("일반 todo") {
                    snapshot.appendSections(["일반 todo"])
                }
                snapshot.appendItems([item], toSection: "일반 todo")
            }
            
        }
        collectionViewDataSource.apply(snapshot, animatingDifferences: true)
    }

```



> ⚠️아쉬운점: SectionIdentifierType 을 String 으로 한점.
>
> why? 아무래도 리터럴 값이기 때문에, human error 가 날 가능성이 매우 높음 



<br/>

### 5. Dark and Light Mode

![다크모드](https://user-images.githubusercontent.com/106936018/206979434-4e52d432-89a0-4178-9f86-242463d61dac.gif)





<br/><br/>

## 회고

<br/>

기획, 디자인 개발 혼자 하면서 느낀점

<br/>

### 기획

기술적 한계, 구체적인 기획을 하지 못한채 앱을 만들어서 기획을 5번 넘게 바꾸는 경험을 하였습니다.

기획하는 시간을 충분히 가져야 하고, 아무리 좋은 기술, 좋은 성능을 가진 앱이라도,

서비스 지향적 사고가 안담긴 앱은 좋은앱이 아니라는걸 다시한번 깨달음

<br/>

> ex) 나는 주차별로 todo를 관리하는게 굉장히 simple 해서 좋다고 생각하고 만들었지만, 
>
> 대부분 피드백 주신분들이 불편하다고 호소 --> ✅향후 달력을 직접 만들어서 대응 (바닐라 코딩을 선호해서)

<br/><br/>

### 디자인

Apple 의 Design 을 사랑 하기 때문에, 많은 iPone 기본앱을 참조 하며 만들고, HIG 도 참고 하면서 디자인 하였습니다.

따라서, User 들에게 이질감 없는 앱 사용성을 제공 할 수 있었습니다.

또한, simple 한 디자인을 매우 지향 하였습니다.(todod의 기능에만 충실 하고, user 가 앱 정체성을 한눈에 알기 쉽게)

<br/>

아쉬운 점으로는, 

최대한 simple 하게 만들기 위해, 부가적인 기능을 더 넣을려고 생각을 못했습니다(학습 측면에서는 조금은 아쉬움)

<br/><br/>

### 개발

개발을 해나가는데  있어 중요한 덕목중 하나는 document 를 참고하여 코드를 구성 할 수 있는 능력 이라고 생각 하고 있습니다.

따라서 도전한  디퍼블과 컴포지셔널레이아웃...

정말 많이 도전적이였고, 1~2주 동안 원하는 cell 의 형태가 안나와서 포기할까 생각 하였지만, 

끝내 성공하여 많이 뿌듯하고, 

한번 api 를 공부 해보니 apple에서 말하는 naming 이나 키워드 등이 다른 api 를 공부 할때도 많이 도움이 되고

 다른 trendy 한 기술을 익히는데 거부감이 확실히 없어져서 너무 좋았습니다.



<br/><br/>

## Progressing....(향후 update 예정)



* 주차별로 todo 를 관리 하는것이 불편 하다고 피드백을 많이 받았습니다.

* User입장에서 기획을 못한 것에 대한 뒤늦은 깨달음을 느끼고 직접 만든 달력을 넣어 update 예정 



<br/>







![달력](https://user-images.githubusercontent.com/106936018/206980175-0a407316-8039-40fc-ab43-2ca675b37829.gif)



<br/>

> ❌문제점: Cell(날짜 한개한개)이 data 를 가지고 있도록 구성 하여서, MVC 패턴에 위배 
>
> ✅리펙토링방향: item에 그날짜의 date 를 가지고 있게 해서, 
>
> 데이터가 fetch 될때 해당 날짜에 todo 를 뿌려주는 식으로 해보기

























