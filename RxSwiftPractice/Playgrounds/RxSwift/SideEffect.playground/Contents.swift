import UIKit
import RxSwift
import RxCocoa
//
let observable = Observable<Int>.create { observer in
    observer.onNext(5)
//    observer.onCompleted()
    return Disposables.create()
}
//
//observable.do(onNext: {
//    print("Do on next \($0)")
//}, afterNext: {
//    print("Do after next \($0)")
//}, onCompleted: {
//    print("On complete side effect")
//}, afterCompleted: {
//    print("After complete side effect")
//}, onSubscribe: {
//    print("Subcribe side effect")
//}, onSubscribed: {
//    print("Subcribed side effect")
//}, onDispose: {
//    print("Dispose Side effect")
//}).subscribe(onNext: {
//    print("Print: \($0)")
//}, onCompleted: {
//    print("Print: Complete")
//}, onDisposed: {
//    print("Dispose")
//})
//
//let single = Single<Int>.create { observer in
//    observer(.success(6))
////    observer.onCompleted()
//    return Disposables.create()
//}
//
//single.do(onSuccess: {
//    print("On success: \($0) - Side Effect")
//}, afterSuccess: {
//    print("After Success: \($0) - Side Effect")
//}, onError: {
//    print("On error: \($0) - Side Effect")
//}, afterError: {
//    print("After error: \($0) - Side Effect")
//}, onSubscribe: {
//    print("On subcribe - Side Effect")
//}, onSubscribed: {
//    print("On subcribed - Side Effect")
//}, onDispose: {
//    print("On dispose - Side Effect")
//}).subscribe { single in
//    switch single {
//    case .success(let value):
//        print("Success with value: \(value) - Subcribe")
//    default:
//        print("Error - Subcribe")
//    }
//}

extension Observable {
    func trackActivity() -> Observable<Element> {
        return self.do(onNext: {
            print("Do on next: \($0)")
        }, onCompleted: {
            print("On complete")
        }, onSubscribe: {
            print("On subcribe")
        }, onSubscribed: {
            print("On subcribed")
        }, onDispose: {
            print("On disposedy")
        })
    }
}

observable.trackActivity()
    .subscribe { value in
        print(value.element)
}
