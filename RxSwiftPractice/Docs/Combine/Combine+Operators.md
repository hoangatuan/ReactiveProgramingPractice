## Operation
### Transform
- collect(), collect(x)
- map, flatMap, tryMap
- replaceNil(with)

- scan(_:_:): ~ reduce

### Filter
- filter
- removeDuplicates
- compactMap
- ignoreOutput: all values are ignore, just emit completion event.
- first(where:) + last(where:): emit only the first or the last value matching the provided predicate, respectively; then emit complete event immediately.

- dropFirst(x)
- drop(while: ): ignores any values emitted by the publisher ***until the first time that predicate is met***

- prefix(x)
- prefix(while: ): lets values from the upstream publisher through as long as the result of that closure is true. After that, emit complete event
- prefix(untilOutputFrom:)

### Combining
- prepend(x)
    + Sequence: [], Set, ...
    + Publisher:
        The prepended Publisher need to emit completed event to lead

- append(o): takes a variadic list of type Output but then appends its items ***after the original publisher has completed with a .finished event.***

- switchToLatest

- merge(with:)
    // same as RxSwift
    Only completed when all publishers are complete

- combineLatest
    // same as RxSwift
    Only completed when all publishers are complete

- zip
    // same as RxSwift
    Only completed when all publishers are complete

### Sequence Operator
- min, max, first, last,
- output(at: ), output(in: )

- count() -> int
- contains(x) -> bool
- allSatisfy { } -> bool## Operation
### Transform
- collect(), collect(x)
- map, flatMap, tryMap
- replaceNil(with)

- scan(_:_:): ~ reduce

### Filter
- filter
- removeDuplicates
- compactMap
- ignoreOutput: all values are ignore, just emit completion event.
- first(where:) + last(where:): emit only the first or the last value matching the provided predicate, respectively; then emit complete event immediately.

- dropFirst(x)
- drop(while: ): ignores any values emitted by the publisher ***until the first time that predicate is met***

- prefix(x)
- prefix(while: ): lets values from the upstream publisher through as long as the result of that closure is true. After that, emit complete event
- prefix(untilOutputFrom:)

### Combining
- prepend(x)
    + Sequence: [], Set, ...
    + Publisher:
        The prepended Publisher need to emit completed event to lead

- append(o): takes a variadic list of type Output but then appends its items ***after the original publisher has completed with a .finished event.***

- switchToLatest

- merge(with:)
    // same as RxSwift
    Only completed when all publishers are complete

- combineLatest
    // same as RxSwift
    Only completed when all publishers are complete

- zip
    // same as RxSwift
    Only completed when all publishers are complete

### Sequence Operator
- min, max, first, last,
- output(at: ), output(in: )

- count() -> int
- contains(x) -> bool
- allSatisfy { } -> bool
