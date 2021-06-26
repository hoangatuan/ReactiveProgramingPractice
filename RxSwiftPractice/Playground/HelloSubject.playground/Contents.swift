import RxSwift
import RxCocoa

/*
 4 types of subject:
 - PublishSubject: only emit element after subscribed
 - BehaviorSubject: emit last element and element after subscribed
 - ReplaySubject: emit n element and element after subscribed // or use createUnbounded() for cache all emited element
 - BehaviorRelay & SubjectRelay: Never end, only emit value, never emit complete or error.
 
 */

// Publish
print(" ----- Publish -----")
let publish = PublishSubject<String>()
publish.onNext("0") // Not emit this because doesn;t have subscribers,

let sub = publish.subscribe(onNext: { print($0) }, onCompleted: { print("Sub1 Complete") }, onDisposed: { print("Disposed") })
publish.onNext("a")
publish.onNext("b")

let observable = publish.asObservable().subscribe({ print("Observable \($0)") })
publish.onNext("c")
publish.onCompleted()

//publish.a

//let sub2 = publish.subscribe(onNext: { print($0) }, onCompleted: { print("Sub2 Complete") }, onDisposed: { print("Disposed") }) // Sub2 will only receive event COMPLETE.
//publish.onNext("c") // Not emit this because it completed.
//
//print(" ----- Behavior -----")
//let behavior = BehaviorSubject(value: 5)
//behavior.onNext(4)
//
//let sub3 = behavior.subscribe(onNext: { print($0) }, onCompleted: { print("sub3 Complete") }, onDisposed: { print("Disposed") })
//behavior.onNext(6)
//behavior.onCompleted()
//
//let sub4 = behavior.subscribe(onNext: { print($0) }, onCompleted: { print("sub4 Complete") }, onDisposed: { print("Disposed") }) // only receive event COMPLETE.
//
//print(" ----- Replay -----")
//let relay = ReplaySubject<Int>.create(bufferSize: 2)
//relay.onNext(1)
//relay.onNext(2)
//relay.onNext(3)
//
//relay.subscribe(onNext: { print($0) }, onCompleted: { print("sub5 Complete") }, onDisposed: { print("Disposed") })
//relay.onNext(4)
//relay.subscribe(onNext: { print($0) }, onCompleted: { print("sub6 Complete") }, onDisposed: { print("Disposed") })
//relay.onCompleted()
//
//relay.subscribe(onNext: { print($0) }, onCompleted: { print("sub7 Complete") }, onDisposed: { print("Disposed") }) // receive buffersize event + event COMPLETE.
//
//


print(" ----- BehaviorRelay -----")
private let image = BehaviorRelay<Int>(value: 2)
image.accept(4)
print(image.value)

