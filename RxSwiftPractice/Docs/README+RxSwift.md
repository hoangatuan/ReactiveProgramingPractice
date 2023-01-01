# Contents
// Basics
- Observable
    - Traits
- Subjects
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
- Memory Management
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

## Subjects
Subject work as Observable and Observer, and they can emit value manually.
4 types:
 - PublishSubject: only emit element after subscribed
 - BehaviorSubject: emit last element and element after subscribed
 - ReplaySubject: emit n element and element after subscribed // or use createUnbounded() for cache all emited element
 
 - BehaviorRelay & SubjectRelay: ***Never end, only emit value, never emit complete or error.***

## Operators

### Filter 

1. Ignore Elements Operators
    - ignoreElements()
    - elementAt(x))
    - filter { ... }
 
2. Skip Operators
    - skip(n): Ignore n first element
    - skipWhile { }: skip while a condition is met, then take everything
    - skipUntil(observable): Skip until another observable emit first element.

3. Taking Operators
    - take(n): Only receive n first element
    - takeWhile { }: take while a condition is met, then ignore everythings
    - takeUntil(observable): Take until another observable emit first element.
 
4. Distinct Operators
    - distinctUntilChanged(): Ignore same element continuosly

### Transforming

1. Transform
    - toArray
    - map: use as normal map
    - enumerated: use as normal enumerated
 
2. Transforming inner observables
    - flatMap: get the observable in one Custom Object
    - flatMapLatest: = flatMap + switchLastest
    
3. 
    - materialize() -> wrap element to next(element)
    - dematerialize() -> unwrap next(element) to element

### Combining

1. Prefixing and concatenating
    + startWith: Add n elements to head of observable.
    + concat: Merge 2 observable to 1 observable.
    + concatMap: = concat + map
 
2. Merging
    + merge: merge 2 subject
 
3. Combining
    + combineLatest(o1, o2): Create new observable from o1,o2 and ***merge latest element*** of o1 and o2 and emit it.
    + zip(o1, o2): Create new observable from o1,o2 and merge ***same index*** element and emit it
 
4. Trigger
    + withLatestFrom(o2): create new observable from o1, o2. when o1 emit -> o2 will emit with lastest value.
    + sample: similar to with latest from
 
5. Switches
    + amb(o2): create new observable from o1, o2. Only emit element of the first observable (o1,o2) emited.
    + switchLatest: emit element of the latest observable joined.

6.
    + reduce: use as normal reduce
    + scan: Similar to reduce but will emit every time when get a new element.

### Time-Based

## RxCocoa

### Binding

- **bind(to: ObserverType)
- Binder is a type confirm to ObserverType -> Can create instance of Binder to handle binding logic

### Traits

#### Attributes

- Can't error
- observed and subscribe on Main thread
- Share resources: ***Driver auto gets share(replay: 1), Signal gets share()***

#### ControlProperty & ControlEvent

- ControlProperty is used to represent properties of objects that ***can both be read and modified.***
    `
    public var text: ControlProperty<String?> {
        return value
    }
    `
- ControlEvent is used to listen for a certain event of the UI component
    - Example:
    `
    public var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
    `
    - use **controlEvent(Event)** to get events
    `
    searchCityName.rx
        .controlEvent(.editingDidEndOnExit)
    `

#### Driver & Signal

- Driver: ***always shares resources and replays its latest value to new consumers upon subscription.*** -> is more suitable for modeling state
- Signal: ***doesn't replay its latest value*** to new consumers upon subscription. -> is more suitable for modeling events

## Error Handing

**catch**
    - catchError, catchErrorJustReturn, ...
**retry**
    - retry() //until success, retry(max: x), retryWhen { } 

## Custom Reactive Extension

### Extend .rx
`
extension Reactive where Base: ... {

}
`

### Create custom Operators
`
extension ObservableType where Element == ... {

}

extension ObservableType {

}
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
let loginAction: Action<(String, String), Bool> = Action
{ credentials in
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

 
