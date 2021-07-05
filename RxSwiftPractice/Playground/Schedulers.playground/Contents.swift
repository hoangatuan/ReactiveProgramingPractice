import UIKit
import RxSwift

/* NOTE:
 - Schedulers is where process take place.
 - Schedulers is not thread.
 - To switch between schedulers WHERE PROCESS TAKE PLACE -> call subcribeOn. If not call subcribeOn -> RxSwift use MainScheduler by default.
 - To switch between schedulers WHERE OBSERVATION TAKE PLACE -> call observeOn.
 
 */


let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
let serialGlobalScheduler = SerialDispatchQueueScheduler(queue: DispatchQueue.global(), internalSerialQueueName: "a")

let observable = Observable<Int>.create { observer in
    observer.onNext(5)
    return Disposables.create()
}


let subcriber = observable
    .subscribeOn(globalScheduler)
    .observeOn(MainScheduler.instance)
