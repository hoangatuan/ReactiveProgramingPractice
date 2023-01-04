## Resource Management

### Memory Management

When subscribe a publisher, Combine doesn't auto create a retain cycle like RxSwift. Instead, you need to keep a strong reference to that subscription manually by storing it in an array/set.

`
var storage = [AnyCancellable]() / [AnyCancellable]()

...
.store(in:&self.storage)
`

Refer: https://www.apeth.com/UnderstandingCombine/subscribers/subscribersanycancellable.html

### Sharing Resource

**share()**
- Same as RxSwift `share()` operator

**multicast**
- Creates a ConnectablePublisher that publishes values through a Subject. It allows you to subscribe multiple times to the subject, then call the publisher‘s connect() method when you‘re ready
- `autoConnect()`

**Future**
- = Async + share(scope: .forever) in RxSwift
