
# Contents
- Publisher
- Subscriber
- Operation
- Side Effects
- Debugging
- Resource Management
- Note

## Publisher<Output, Failure>

### Definition

- This protocol defines the requirements for a type to be able to transmit a sequence of values over time to one or more subscribers
- can emit zero or more values but only one completion event (normal completion event / an error)
    + Once complete -> Can't longer emit events

### How to create

- using `.publisher`

- `Just($valueToEmit)`<T, Never>:
    + ***a publisher that emits its output to each subscriber once and then finishes.***
    + Same with Observable.just in RxSwift

- `Published`:
    + creates a publisher for value in addition to being accessible as a regular property.
    + Use the $ prefix on the @Published property to gain access to its underlying publisher
    + the values emitted will be the initial value at subscription time followed by new values when the property changes
    > Note: ***When a @Published variable is changed, its publisher publishes the new value before the variable itself is set to the new value***

- `Future`: ***Perform async work immediately (without waiting for subscriptions) only once and deliver the result to any amount of subscribers.***
    + ***asynchronously produce a single result and then complete***
    + Upon creation, it immediately invokes your closure to start computing the result and fulfill the promise ***as soon as possible***
    + ***Future is a class, not a struct.***
    + ***It stores the result of the fulfilled Promise and delivers it to current and future subscribers.*** ( = share(scope: .forever) in RxSwift?)
    
    + Can wrap Future with `Deferred`, so that Future will not execute until it has a subscriber.
    `
    Deferred {
        Future<I,O> { promise ... }
    }
    `
- **Empty**: A publisher never emit value

- **Fail**: A publisher that immediately terminates with the specified error.

- **AnyPublisher**

- Timer Publisher: https://www.apeth.com/UnderstandingCombine/publishers/publisherstimer.html

### Subject

- PassthroughSubject

    let subject = PassthroughSubject<String, MyError>()
    subject.send(...)

- CurrentValueSubject

    let subject = CurrentValueSubject<Int, Never>(0)

### AnyPublisher

- AnyPublisher is a type-erased struct that conforms the Publisher protocol.
- AnyPublisher does not have a send(_:) operator, so you cannot add new values to that publisher directly. => Use to let outside scope can only subscribe and can't send new event

`eraseToAnyPublisher()`


### How to subscribe

- subscribe(x: Subscriber)
- func sink(receiveCompletion: f1, receiveValue: f2) -> AnyCancellable

## Subscriber

- is a protocol that defines the requirements for a type to be able to receive input from a publisher.
- Create custom subscriber

### How to create:

***Subscribers.Assign(object: self.iv, keyPath: \UIImageView.image)***

### How to subscribe:

- sink(_:_:): with 2 closures, 1 to handle completion event (success/failure), e to handle values event
    `
    func sink(receiveCompletion: f1, receiveValue: f2) -> AnyCancellable
    `
    
- assign(to:on:):
    + assign the received value to a KVO-compliant property of an object
    + only works on publishers that cannot fail
    + ***Easily to create retain cycle***
        Retain cycle example:  .assign(to: \.currentDate, on: self)
        Fix retain cycle:
            + .assign(to: &$currentDate)
            + sink { [weak self] ... }
            + Use `CombineExt`: .assign(to: \.currentDate, on: self, ownership: .weak)

## Cancellable

- AnyCancellable conforms to the Cancellable protocol

## Operation

- Read more in Combine+Operators.

## Side effects

**handleEvents**

## Debugging

- `print("...")`
    + can use the print operator anywhere in your operator chain to see exactly what events occur at that point.
    + Print details: when receive subscription, number of value request, emited value, completion event

- `breakpointOnError()`:  if any of the upstream publishers emits an error, Xcode will break in the debugger to let you look at the stack

- `breakpoint(receiveSubscription:receiveOutput:receiveCompletion:)`:  intercept all events and decide on a case-by-case basis whether you want to pause the debugger.

## Key-Value Observing

- Using `publisher(for: KeyPath, options:)` to subscribe for changed of a property (***must be @objc dynamic*** property)
    + using `options` to determine whether you want init/previous value

- ObservableObject & @Published
    + when conforming to ObservableObject protocol, your classes will have `objectWillChange` publisher

## Resource Management

Read more in Combine+ResourceManagement

## Error Handling

**Never**
- turn your Never-failing publisher into one that may fail
    + setFailureType(to: CustomError.Type)

**Dealing with failure**
- tryMap with mapError (cuz when using tryMap, error's type will be erase to Error, so need to use mapError to convert to concrete Error type)
- .retry(x)
- .replaceError(with: x)

**Catch**
`
.catch { error in 
    return Empty<T,Never>()
}
`

## Schedulers

- subscribe(on:): creates the subscription (start the work) on the specified scheduler.
- receive(on:): delivers values on the specified scheduler.

## Custom Publishers

Read more on Combine+Custom

## Special
- drop(untilOutputFrom:): Wait for other publisher to publish first value
- prefix(untilOutputFrom:)

## Note

- More info at Combine+Note

## Docs

- https://www.apeth.com/UnderstandingCombine/tricksandtips.html
- https://medium.com/@mshcheglov/mvvm-design-pattern-with-combine-framework-on-ios-5ff911011b0b
