//
//  APIClientService.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 03/01/2023.
//

import Foundation

import Foundation
import Combine

enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol EndpointType {
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var urlParameters: [String: String]? { get }
    var bodyParameters: [String: String]? { get }
    var headers:  [String: String]? { get }
}

protocol Mappable {
    associatedtype Input
    associatedtype Output

    func map(input: Input) -> Output
}

protocol APIClientService {
    func request<T: Decodable, M: Mappable>(
        endpoint: EndpointType,
        for type: T.Type,
        mapper: M,
        completion: @escaping (M.Output) -> Void,
        error: @escaping (APIError) -> Void
    )
}

//final class APIClientServiceImplementation: APIClientService {
//    func request<T, M>(
//        endpoint: EndpointType,
//        for type: T.Type,
//        mapper: M,
//        completion: @escaping (M.Output) -> Void,
//        error: @escaping (APIError) -> Void
//    ) where T : Decodable, M : Mappable {
////        guard let url = endpoint.
//        URLSession.shared.dataTask(with: URLRequest(url: end), completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
//    }
//}
