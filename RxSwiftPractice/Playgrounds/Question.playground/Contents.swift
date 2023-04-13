
import UIKit
import RxSwift

let bag = DisposeBag()
//
// Proved: Each time subscribe to Observable, it will emits again by run through it's create body or it's stream

//func createObservable() -> Observable<Bool> {
//    return Observable.create { subcriber in
//        print("ABC")
//        subcriber.onNext(true)
//
//        return Disposables.create()
//    }
//}
//
//let isSuccess = createObservable()
//    .do(onNext: { _ in
//        print("Is success on next")
//    }, onDispose: {
//        print("On dispose")
//    })
////    .share() // = 0 replay
//    .share(replay: 1)
//
//isSuccess
//    .filter({ $0 })
//    .subscribe(onNext: {_ in
//        print("On next 1")
//    }, onDisposed: {
//        print("On dispose 1")
//    })
//    .disposed(by: bag)
//
//isSuccess
//    .filter({ $0 })
//    .subscribe(onNext: {_ in
//        print("On next 2")
//    }, onDisposed: {
//        print("On dispose 2")
//    })
//    .disposed(by: bag)
//


let publishRelay = PublishSubject<Void>()

func create(input: Observable<Void>) -> Observable<Void> {
    input.do(onNext: {
        print("On next 1")
    })
    .map { return 2 }
    .map { _ in return () }
}

struct Input {
    let input: Observable<Void>
}

struct Output {
    let output: Observable<Void>
}

func transform(input: Input) -> Output {
    return Output(output: create(input: input.input))
}

let output = transform(input: Input(input: publishRelay.asObserver()))

output.output.subscribe(onNext: {
    print("On next 2")
})
.disposed(by: bag)

output.output.subscribe(onNext: {
    print("On next 3")
})
.disposed(by: bag)

publishRelay.onNext(())
