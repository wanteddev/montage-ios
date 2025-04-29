Instance Method

# iconButton(_:action:) 

카테고리 컴포넌트 오른쪽에 표시할 아이콘 버튼을 설정합니다.

```swift
@MainActor
func iconButton(
    _ icon: Icon,
    action: @escaping () -> Void
) -> Category
```

## Parameters 

icon

표시할 아이콘

action

버튼 클릭 시 실행할 액션

## Return Value 

수정된 카테고리 인스턴스

