import UIKit
import RxSwift
import RxCocoa

// Ref: https://medium.com/@_achou/rxswift-share-vs-replay-vs-sharereplay-bea99ac42168

let bag = DisposeBag()

func networkRequestAPI(query: String) -> Observable<Bool> {
    return Observable.create { observer in
        print("Execute")
        let isSuccess = query == "true"
        observer.onNext(isSuccess)
        observer.onCompleted()
        return Disposables.create()
    }
}

let tapObservable = PublishSubject<String>()
let res = tapObservable.flatMap({ networkRequestAPI(query: $0) }).share(replay: 2)

res.subscribe(onNext: {
    print("Check 1: \($0)")
}, onDisposed: {
    print("Dispose check 1")
}).disposed(by: bag)

res.subscribe(onNext: {
    print("Check 2: \($0)")
}, onDisposed: {
    print("Dispose check 2")
}).disposed(by: bag)


tapObservable.onNext("true")

tapObservable.onCompleted()

tapObservable.onNext("false")



//res.subscribe(onNext: {
//    print("Check 3: \($0)")
//}).disposed(by: bag)
