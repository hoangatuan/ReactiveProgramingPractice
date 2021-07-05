import UIKit
import RxSwift
import RxCocoa

/* NOTE:
 Convert/bind from type A to type B:
 - If convert failed + type B accpet error => B will emit an error tell why convert failed.
 + Example:
    + Convert fail from Observable type => Trait type, fail but not crash
 
 - If convert failed + type B doesn't accept error => Crash
    + Example:
        + Convert from subject => relay. Relay doesnt' accept error. If we pass error -> Crash
        + Binder doesn;t accept error => Bind error to binder => crash
 
 */


enum MyError: Error {
    case anError
}

let relay = PublishRelay<Int>()
let observable = PublishSubject<Int>()
let disposeBag = DisposeBag()

let observable2 = Observable<Int>.create { observer in
//    observer.onNext(4)
    observer.onNext(5)
//    observer.onCompleted()
    
    return Disposables.create()
}

observable2.asMaybe().subscribe { value in
    print("value: \(value)")
} onError: { err in
    print("err0r: \(err)")
} onCompleted: {
    print("complete")
}



//observable
//    .bind(to: relay)
//    .disposed(by: disposeBag)
//
//relay.subscribe { value in
//    print("On next: \(value)")
//} onError: { error in
//    print("On error: \(error)")
//} onCompleted: {
//    print("On completed")
//} onDisposed: {
//    print("On disposed")
//}.disposed(by: disposeBag)
//
//observable.onNext(5)
//observable.onNext(6)
//observable.onCompleted()
//observable.onError(MyError.anError)

