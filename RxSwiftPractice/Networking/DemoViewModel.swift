//
//  DemoViewModel.swift
//  RxSwiftPractice
//
//  Created by Digilife on 13/06/2021.
//

import Foundation
import RxSwift

enum APIError: Error {
    case error(String)
    case errorURL
    
    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        case .errorURL:
            return "URL String is error."
        }
    }
}

class DemoViewModel {
    func register(username: String?, password: String?, email: String?) -> Observable<Bool> {
        return Observable.create { observer in
            if username == nil || username?.isEmpty ?? true {
                observer.onError(APIError.error("Empty user name"))
            } else if password == nil || password?.isEmpty ?? true {
                observer.onError(APIError.error("Empty password"))
            } else if email == nil || email?.isEmpty ?? true {
                observer.onError(APIError.error("Empty email"))
            } else {
                observer.onNext(true)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func registerWithTrait(username: String?, password: String?, email: String?) -> Completable {
        return Completable.create { observer in
            if username == nil || username?.isEmpty ?? true {
                observer(.error(APIError.error("Empty user name")))
            } else if password == nil || password?.isEmpty ?? true {
                observer(.error(APIError.error("Empty password")))
            } else if email == nil || email?.isEmpty ?? true {
                observer(.error(APIError.error("Empty email")))
            } else {
                observer(.completed)
            }
            
            return Disposables.create()
        }
    }
}
