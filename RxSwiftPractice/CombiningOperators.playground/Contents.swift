import RxSwift

/*
1. Prefixing and concatenating
    + startWith: Add n elements to head of observable.
    + concat: Merge 2 observable to 1 observable.
    + concatMap: = concat + map
 
2. Merging
    + merge: merge 2 subject
 
3. Combining
    + combineLastest(o1, o2): Create new observable from o1,o2 and merge lastest element of o1 and o2 and emit it.
    + zip(o1, o2): Create new observable from o1,o2 and merge same index element and emit it
 
4. Trigger
    + withLastestFrom(o2): create new observable from o1, o2. when o1 emit -> o2 will emit with lastest value.
    + sample: similar to with lastest from
 
5. Switches
    + amb(o2): create new observable from o1, o2. Only emit element of the first observable (o1,o2) emited.
    + switchLastest: ?

6.
    + reduce: use as normal reduce
    + scan: Similar to reduce but will emit every time when get a new element.
 
 Refer: https://fxstudio.dev/rxswift-combining-operators/#1_Prefixing_and_concatenating
 */

let bag = DisposeBag()

debugPrint(" --- Start with Demo --- ")

Observable.of("B", "C", "D")
    .startWith("A", "A", "A") // start with 1 or n elements.
    .subscribe({ print($0) })
    .disposed(by: bag)

debugPrint(" --- Concat Demo --- ")
let first = Observable.of("A", "B", "C")
let second = Observable.of("D", "E", "F")

let observable = first.concat(second)
//let observable = Observable.concat([first, second])

observable
    .subscribe(onNext: { value in
        print(value)
    })
    .disposed(by: bag)


debugPrint(" --- Merge Demo --- ")
let firstSb = PublishSubject<String>()
let secondSb = PublishSubject<String>()
PublishSubject.merge([firstSb, secondSb])
    .subscribe({print($0)})
    .disposed(by: bag)

firstSb.onNext("1")
secondSb.onNext("Mot")
firstSb.onNext("2")
secondSb.onNext("Hai")
firstSb.onCompleted()
firstSb.onNext("3")
secondSb.onNext("Ba")

debugPrint(" --- Combine Lastest Demo --- ")

let chu = PublishSubject<String>()
let so = PublishSubject<String>()
let observable1 = Observable.zip(chu, so)

observable1
    .subscribe(onNext: { (value) in
        print(value)
    })
    .disposed(by: bag)

chu.onNext("Một")
chu.onNext("Hai")
so.onNext("1")
so.onNext("2")

chu.onNext("Ba")
so.onNext("3")
chu.onCompleted() // After o1 complete, o2 still get the lastest element of o1 to combine and emit
chu.onNext("Bốn")
so.onNext("4")
so.onNext("5")
so.onNext("6")


