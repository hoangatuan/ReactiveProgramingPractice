## Operators

### Filter 

1. Ignore Elements Operators
    - ignoreElements()
    - elementAt(x))
    - filter { ... }
 
2. Skip Operators
    - skip(n): Ignore n first element
    - skipWhile { }: skip while a condition is met, then take everything
    - skipUntil(observable): Skip until another observable emit first element.

3. Taking Operators
    - take(n): Only receive n first element
    - takeWhile { }: take while a condition is met, then ignore everythings
    - takeUntil(observable): Take until another observable emit first element.
 
4. Distinct Operators
    - distinctUntilChanged(): Ignore same element continuosly

### Transforming

1. Transform
    - toArray
    - map: use as normal map
    - enumerated: use as normal enumerated
 
2. Transforming inner observables
    - flatMap: get the observable in one Custom Object
    - flatMapLatest: = flatMap + switchLastest
    
3. 
    - materialize() -> wrap element to next(element)
    - dematerialize() -> unwrap next(element) to element

### Combining

1. Prefixing and concatenating
    + startWith: Add n elements to head of observable.
    + concat: Merge 2 observable to 1 observable.
    + concatMap: = concat + map
 
2. Merging
    + merge: merge 2 subject
 
3. Combining
    + combineLatest(o1, o2): Create new observable from o1,o2 and ***merge latest element*** of o1 and o2 and emit it.
    + zip(o1, o2): Create new observable from o1,o2 and merge ***same index*** element and emit it
 
4. Trigger
    + withLatestFrom(o2): create new observable from o1, o2. when o1 emit -> o2 will emit with lastest value.
    + sample: similar to with latest from
 
5. Switches
    + amb(o2): create new observable from o1, o2. Only emit element of the first observable (o1,o2) emited.
    + switchLatest: emit element of the latest observable joined.

6.
    + reduce: use as normal reduce
    + scan: Similar to reduce but will emit every time when get a new element.


### Time-Based
