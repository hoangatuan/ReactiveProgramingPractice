## Resource Management

**share()**
- Same as RxSwift `share()` operator

**multicast**
- Creates a ConnectablePublisher that publishes values through a Subject. It allows you to subscribe multiple times to the subject, then call the publisher‘s connect() method when you‘re ready
- `autoConnect()`

**Future**
- = Async + share(scope: .forever) in RxSwift
