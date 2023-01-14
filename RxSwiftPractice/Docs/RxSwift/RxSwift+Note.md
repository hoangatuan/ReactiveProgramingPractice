#  Note

1. 

Convert/bind from type A to type B:
 - If convert failed + type B accept error => B will emit an error tell why convert failed.
 + Example:
    + Convert fail from Observable type => Trait type, fail but not crash
 
 - If convert failed + type B doesn't accept error => Crash
    + Example:
        + Convert from subject => relay. Relay doesn't accept error. If we pass error -> Crash
        + Binder doesn't accept error => Bind error to binder => crash

2.

 - To switch between schedulers WHERE PROCESS TAKE PLACE -> call `subscribeOn`. If not call subscribeOn -> RxSwift ***use MainScheduler by default***.
 - To switch between schedulers WHERE OBSERVATION TAKE PLACE -> call `observeOn`.

3. RxCocoa
- A button can have rx.tap and IBaction at the same time.
- if set text property, must call sendActions(for: .valueChanged) to trigger subscriber.
    - https://stackoverflow.com/questions/33815399/rxswift-uilabel-field-not-being-updated-when-uitextfield-updated-programmatica

4.
- Use `asObservable` to convert subject to Observable -> hide `send(event)` actions from outside client (example: ViewModel hide send(event) from ViewController)
- Create Binder in ReactiveExtension for more clear and clean.

5. 
There are 3 types of events: next(Element), error(Error), complete
- if a subscription chain generates an error or a completion event, the entire chain shuts down.
- If return error from `flatMap`, it will terminal the whole subscription chain. Otherwise, if `flatMap` return .completed events -> It doesn't pass .complete to the chain. Instead, it's simply a signal that this subscription has completed and you no longer need to monitor it.
- the Observable inside `flatMap` will only be subscribe when it starts receive event to create that Observable.

