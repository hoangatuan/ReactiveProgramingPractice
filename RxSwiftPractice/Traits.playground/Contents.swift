import RxSwift

/* TRAITS
 - Trait là một wrapper struct với một thuộc tính là một Observable Sequence nằm bên trong nó.
 
 Example:
 struct Single<Element> {
     let source: Observable<Element>
 }
 
 
 - Để chuyển Trait về thành Observable, chúng ta có thể sử dụng operator .asObservable()
 
 - Đặc điểm:
    + không xảy ra lỗi.
    + observe và subscribe trên MainScheduler.
    + không chia sẻ Side Effect. ??
 
 - 3 TYPES of Trait:
    + Single: Only emit .success(value) or .error(value)
    + Completable: Only emit .completed or .error(value)
    + Maybe: Can emit .success(value) or .error(value) or .completed
 
-> After emit 1 event -> terminate
 */


print(" --- Single Demo --- ")
let single1 = Single<String>.create { single in
    single(.success("Successss")) // Terminate after emit 1 event
    single(.success("Successss2")) // Not emit this event
    
    return Disposables.create()
}.subscribe(onSuccess: { print($0) }, onError: { print($0) })

print(" --- Completable Demo --- ")
let completable1 = Completable.create { compleable in
    compleable(.completed) // Terminate after emit 1 event
    compleable(.completed) // Not emit this event
    
    return Disposables.create()
}.subscribe { event in
    switch event {
    case .completed:
        print("Completed")
    default:
        print(event)
    }
}

print(" --- Maybe Demo --- ")
let maybe1 = Maybe<String>.create { maybe in
    maybe(.success("Success!")) // Terminate after emit 1 event
    maybe(.completed) // Not emit this event
   
    
    return Disposables.create()
}.subscribe(onSuccess: { print("Success: \($0)") }, onCompleted: { print("Maybe Completed" )})

let single2 = Single<String>.create { single in
    single(.success("Successss")) // Terminate after emit 1 event
    single(.success("Successss2")) // Not emit this event
    
    return Disposables.create()
}
