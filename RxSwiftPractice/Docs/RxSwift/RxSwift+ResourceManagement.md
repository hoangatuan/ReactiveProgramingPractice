## Resource Management

### Memory

Example: ViewController store a disposeBag.

Reference explain:
 - View Controller have a strong reference to disposeBag.

`
    public protocol Disposable {
        func dispose()
    }
`

 - When subscribe a Observable, Disposable will create a strong reference to Observable & Observable will create a strong ref to Disposable.
 -> RxSwift create a retain cycle itself to keep subscriber alive, so that user can deallocate subscriber whenever they want.
 
 - To deallocate subscriber, there are 2 ways:
    - When Observable emit `complete` or `error` event, retain cycle will be broken itself. In other case, call `dispose()` manually on each disposable to deallocate them.
    - Add Disposable to a `disposeBag`. DisposeBag will stores all disposables, ,then when view controller deinit, disposeBag will call dispose on every disposable.
        - Reference explain: ViewController -> disposeBag -> disposables. (No retain cycle)
        - Carefully to not let disposables have a strong reference to view controller, otherwise it will create a retain cycle.

### Sharing Resource

- https://medium.com/@_achou/rxswift-share-vs-replay-vs-sharereplay-bea99ac42168
- https://medium.com/gett-engineering/rxswift-share-ing-is-caring-341557714a2d

Understand share(replay:scope:)

- When you call share(), you’re actually calling share(replay: 0, scope: .whileConnected)
- `replay`:  “How many elements would you like me to replay to new subscribers?”.
    - 0: ~ PublishSubject
    - 1: ~ ReplaySubject
- scope:
    - 2 options: `.whileConnected` & `.forever`
    - `whileConnected`: When the number of subscribers drops from 1 to 0, the internal “cache” of the shared stream is cleared. -> New subscriber will need to call new operations
    - `forever`: The internal cache of the stream is not cleared, even after the number of subscribers drops from 1 to 0.
