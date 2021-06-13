import RxSwift

/*
1. Transform
    + toArray
    + map: use as normal map
    + enumerated: use as normal enumerated
 
2: Transforming inner observables
    + flatMap: get the observable in one Custom Object
    + flatMapLastest: = flatMap + switchLastest
 
 */

let bag = DisposeBag()

debugPrint(" --- ToArray Demo --- ")
Observable.of(1, 2, 3, 4, 5, 6)
    .toArray()
    .subscribe(onSuccess: { value in
        print(value)
    })
    .disposed(by: bag)

debugPrint(" ------------ 2. Transforming inner observables ------------ ")
struct User {
    let message: BehaviorSubject<String>
}

debugPrint(" ------------ Flatmap Demo ------------ ")
let cuTy = User(message: BehaviorSubject(value: "Cu Tý chào bạn!"))
let cuTeo = User(message: BehaviorSubject(value: "Cu Tèo chào bạn!"))

let subject = PublishSubject<User>()

subject
    .flatMap { $0.message }
    .subscribe(onNext: { msg in
        print(msg)
    })
    .disposed(by: bag)

// subject
    subject.onNext(cuTy)
    
    // cuTy
    cuTy.message.onNext("Có ai ở đây không?")
    cuTy.message.onNext("Có một mình mình thôi à!")
    cuTy.message.onNext("Buồn vậy!")
    cuTy.message.onNext("....")
    
    // subject
    subject.onNext(cuTeo)
    
    // cuTy
    cuTy.message.onNext("Chào Tèo, bạn có khoẻ không?")
    
    // cuTeo
    cuTeo.message.onNext("Chào Tý, mình khoẻ. Còn bạn thì sao?")
    
    // cuTy
    cuTy.message.onNext("Mình cũng khoẻ luôn")
    cuTy.message.onNext("Mình đứng đây từ chiều nè")
    
    // cuTeo
    cuTeo.message.onNext("Kệ Tý. Ahihi")

debugPrint(" ------------ FlatmapLastest Demo ------------ ")

let cuTy2 = User(message: BehaviorSubject(value: "Tý: Cu Tý chào bạn!"))
let cuTeo2 = User(message: BehaviorSubject(value: "Tèo: Cu Tèo chào bạn!"))

let subject2 = PublishSubject<User>()

subject2
    .flatMapLatest { $0.message }
    .subscribe(onNext: { msg in
        print(msg)
    })
    .disposed(by: bag)

// subject
subject2.onNext(cuTy2) // Emit the default value of behavior

// cuTy
cuTy2.message.onNext("Tý: Có ai ở đây không?")
cuTy2.message.onNext("Tý: Có một mình mình thôi à!")
cuTy2.message.onNext("Tý: Buồn vậy!")
cuTy.message.onNext("Tý: ....")

// subject
subject2.onNext(cuTeo2) // switch to lastest

// cuTy
cuTy2.message.onNext("Tý: Chào Tèo, bạn có khoẻ không?")

// cuTeo
cuTeo2.message.onNext("Tèo: Chào Tý, mình khoẻ. Còn bạn thì sao?")

// cuTy
subject2.onNext(cuTy2) // switch to lastest
cuTy2.message.onNext("Tý: Mình cũng khoẻ luôn")
cuTy2.message.onNext("Tý: Mình đứng đây từ chiều nè")

// cuTeo
cuTeo2.message.onNext("Tèo: Kệ Tý. Ahihi")
