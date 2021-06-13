import RxSwift

/*
1. Ignore Elements Operators
    + ignoreElements
    + elementAt
    + filter
 
2. Skip Operators
    + skip(n): Ignore n first element
    + skipWhile
    + skipUntil(observable: Skip until another observable emit first element.

3. Taking Operators
    + take(n): Only receive n first element
    + takeWhile
    + takeUntil(observable): Take until another observable emit first element.
 
4. Distinct Operators
    + distinctUntilChanged: Ignore same element continously

 */

let bag = DisposeBag()

debugPrint(" --- Ignore Element Demo --- ")
let subject = PublishSubject<Int>()

subject.ignoreElements().subscribe({ event in
    print(event)
}).disposed(by: bag) // Ignore all element -> only emit complete or error.

subject.onNext(1)
subject.onNext(2)
subject.onCompleted()
subject.onNext(3)

debugPrint(" --- Element At Demo --- ")

let subject2 = PublishSubject<Int>()
subject2.elementAt(2).subscribe({ event in
    print(event)
}).disposed(by: bag)

subject2.onNext(1)
subject2.onNext(2)
//subject2.onCompleted() -> If compelete before emit event -> Emit an error(indexOutOfRange)
subject2.onNext(3) // -> Only emit 3
// subject2.onCompleted() Dont need to call this because it will auto complete when emit 3 event


debugPrint(" --- Skip Demo --- ")
let subject3 = PublishSubject<Int>()

subject3.skip(2).subscribe { event in // skip n first element
    print(event)
}.disposed(by: bag)

subject3.onNext(1) // Skip this
subject3.onNext(2) // Skip this
subject3.onNext(3)
subject3.onNext(4)

debugPrint(" --- Skip While Demo --- ")
let subject4 = PublishSubject<Int>()

subject4.skipWhile({ $0 <= 2}).subscribe({ event in // Skip until first element satisfied
    print(event)
})

subject4.onNext(1) // Skip this
subject4.onNext(2) // Skip this
subject4.onNext(3)
subject4.onNext(4)
subject4.onNext(2) // Dont skip this

debugPrint(" --- Skip Until Demo --- ")
// - Skip until another observable emit first element.


debugPrint(" --- TakeWhile Demo --- ")
let subject5 = PublishSubject<Int>()

subject5.takeWhile({ $0 <= 2}).subscribe({ event in
    print(event)
}).disposed(by: bag)

subject5.onNext(1)
subject5.onNext(2)
subject5.onNext(3) // Auto terrminate after this because
subject5.onNext(4)
subject5.onNext(2)

debugPrint(" --- Distinc Until Change Demo Equatable type --- ")

Observable.of("A", "A", "B", "B", "A", "A", "A", "C", "A")
    .distinctUntilChanged()
    .subscribe(onNext: { print($0) })
    .disposed(by: bag)


debugPrint(" --- Distinc Until Change Demo Custom type --- ")

struct Point {
    var x: Int
    var y: Int
}

let array = [ Point(x: 0, y: 1),
              Point(x: 0, y: 2),
              Point(x: 1, y: 0),
              Point(x: 1, y: 1),
              Point(x: 1, y: 3),
              Point(x: 2, y: 1),
              Point(x: 2, y: 2),
              Point(x: 0, y: 0),
              Point(x: 3, y: 3),
              Point(x: 0, y: 1)]

Observable.from(array)
    .distinctUntilChanged { p1, p2 in
        return p1.x == p2.x
    }.subscribe(onNext: { print($0) })
    .disposed(by: bag)
