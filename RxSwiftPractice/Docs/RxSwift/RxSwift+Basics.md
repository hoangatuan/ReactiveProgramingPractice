
# Contents

// Basics
- Observable
    - Traits
- Subjects
- Side Effects
- Operators
    - Filters
    - Transforming
    - Combining
    - Time-Based
- RxCocoa
    - Binding
    - Traits
- Error handling

// Advance
- Resource Management
    - Memory
    - Sharing resource
- Custom Reactive Extension

## Observable 

Observable is just a sequence produce events over a period of time, and it's read-only (we can only provide init value to emits)

### Create

- .just(x)
- .from([]) // -> emits individual element
- .of([]), .of(Sequence) // -> emits array element
- .empty(), .never()
- Observable<T>.create { ... }

### Subscribe

- .subscribe(...)
> If receive `Event<T>`, use `.element` to get value only.

### Traits

Traits is a wrapper ***struct*** with a property is Observable Sequence inside it.
3 types: Single, Maybe, Completable

## Infallible
- Same as Observable but never emit error

Infallible<String>.create { observer in
    observer(.next("Hello"))
    observer(.next("World"))
    observer(.completed)
    // No way to error here

    return Disposables.create {
        // Clean-up
    }
}

## Subjects

Subject work as Observable and Observer, and they can emit value manually.
4 types:
 - PublishSubject: only emit element after subscribed
 - BehaviorSubject: emit last element and element after subscribed
 - ReplaySubject: emit n element and element after subscribed // or use createUnbounded() for cache all emitted element
 
 - BehaviorRelay & SubjectRelay: ***Never end, only emit value, never emit complete or error.***
 
## Side Effects

**do(onNext:onError:onCompleted:onSubscribe:onDispose)**

## Operators

Read more in RxSwift+Operators

## RxCocoa

Read more in RxSwift+RxCocoa

## Error Handing

**catch**
    - catchError, catchErrorJustReturn, ...
**retry**
    - retry() //until success, retry(max: x), retryWhen { } 

## Custom Reactive Extension

### Extend .rx to provide more function

Reactive has 1 typealias: Base
`
extension Reactive where Base: T {

}
`

### Create custom Operators

ObservableType has 1 typealias: Element
`
extension ObservableType where Element == ... {

}

extension ObservableType {

}

...
`
## RxSwiftExt

Some functions: 
- distinct(), repeatWithBehavior(), ...
- pause()
- withUnretained 
- mapMany() // map every individual element inside a collection- typed observable sequence, such as an Array

### Actions

Action is a generic class defined as class Action<Input, Element> -> Take input, perform some work and return output
`
let loginAction: Action<(String, String), Bool> = Action { credentials in
  let (login, password) = credentials
  // loginRequest returns an Observable<Bool>
  return networkLayer.loginRequest(login, password)
}

button.rx.action = buttonAction
`

Action.Input is conform to ObserverType, Action.Output confirms to Observable
-> bind to input, subscribe to outputu

**execute(input)** to execute action manually

### Gesture

## Memory Management

Read more RxSwift+ResourceManagement
