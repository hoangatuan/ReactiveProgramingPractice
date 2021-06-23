import RxSwift

// NOTE
// - Advantages of dispose bag?


// MARK: - Basic
/*
 let helloRx = Observable.just("Hello Rx") // only emit 1 times and complete
 helloRx.subscribe({ print($0) })

 let helloRx2 = Observable<String>.from(["A", "B", "C", "D", "E", "F"]) // -> Dispose single element each time
 helloRx2.subscribe{( print($0))}

 let helloRx3 = Observable.of("A", "B", "C", "D", "E", "F")
 let a = helloRx3.subscribe{( print($0))}

 // Toán tử Create -> Observable
 let bag = DisposeBag()

 let observable = Observable<String>.create { observer in // A way to create Observable
     observer.onNext("1")
     observer.onNext("2")
     observer.onNext("3")

     observer.onCompleted() // When complete or error, observable terminate immediatly
     observer.onNext("4") // -> Not emit this.
     return Disposables.create() // ??
 }

 observable.subscribe(onNext: {
     print($0)
 }, onError: {
     print($0)
 }, onCompleted: {
     print("Completed")
 }, onDisposed: {
     print("Disposed")
 }).disposed(by: bag)
 */

// NOTE:
// - Each time subcribe to an observable, it will make that observable run body again => Should use share() .

var observable: AnyObserver<Bool>?
let bag = DisposeBag()

func aaa() -> Observable<Bool> {
    return Observable.create { subcriber in
        observable = subcriber
        print("ABC")
        subcriber.onNext(false)
        
        return Disposables.create()
    }.share(replay: 1)
}

func check() {
    let isSuccess = aaa()

    isSuccess.filter({ $0 })
        .subscribe { _ in
            print("true")
        }.disposed(by: bag)

    isSuccess.filter({ !$0 })
        .subscribe { _ in
            print("false")
        }.disposed(by: bag)
}


check()
check()
