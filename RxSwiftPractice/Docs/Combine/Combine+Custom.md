## Custom Publishers

Publisher has 2 typealias: Output & Failure
`
extension Publisher {
  func unwrap<T>() -> Publishers.CompactMap<Self, T> where Output == Optional<T> {
    compactMap { $0 }
  }
}
`

> The implementation uses a single compactMap(_:), so the return type derives from this. If you look at Publishers.CompactMap, you see it’s a generic type: public struct CompactMap<Upstream, Output>. When implementing your custom operator, Upstream is Self (the publisher you’re extending) and Output is the wrapped type.

> When developing more complex operators as methods, such as when using a chain of operators, the signature can quickly become very complicated. A good technique is to make your operators return an AnyPublisher<OutputType, FailureType>. In the method, you’ll return a publisher that ends with eraseToAnyPublisher() to type-erase the signature.


Doc:
- Custom Subscriber: https://www.apeth.com/UnderstandingCombine/subscribers/subscriberscustom.html
- Custom Publisher: https://www.apeth.com/UnderstandingCombine/publishers/publisherscustom.html
