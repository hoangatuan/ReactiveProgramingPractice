## RxCocoa

### Binding

- **bind(to: ObserverType)
- Binder is a type confirm to ObserverType 
    -> Can create instance of Binder to handle binding logic
    - Binder doesn't accept Error -> catch error before bind.

### Traits

#### Attributes

- Can't error
- observed and subscribe on Main thread
- Share resources: ***Driver auto gets share(replay: 1), Signal gets share()***

#### ControlProperty & ControlEvent

- ControlProperty is used to represent properties of objects that ***can both be read and modified.*** (~ Observable + Observer)
    `
    public var text: ControlProperty<String?> {
        return value
    }
    `
- ControlEvent is used to listen for a certain event of the UI component (~Observable)
    - Example:
    `
    public var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
    `
    - use **controlEvent(Event)** to get events
    `
    searchCityName.rx
        .controlEvent(.editingDidEndOnExit)
    `

#### Driver & Signal

- Driver: ***always shares resources and replays its latest value to new consumers upon subscription.*** -> is more suitable for modeling state
- Signal: ***doesn't replay its latest value*** to new consumers upon subscription. -> is more suitable for modeling events
