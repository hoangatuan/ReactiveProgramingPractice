//
//  Publisher+Ext.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 05/01/2023.
//

import Foundation
import Combine

extension Publisher {
    func handleLoadingAndError(loadingPublisher: PassthroughSubject<Bool, Never>, errorPublisher: PassthroughSubject<Error, Never>) -> Publishers.HandleEvents<Self> {
        return handleEvents(
            receiveSubscription: { _ in
                loadingPublisher.send(true)
            },
            receiveOutput: {_ in
                loadingPublisher.send(false)
            },
            receiveCompletion: {
                switch $0 {
                case .finished:
                    loadingPublisher.send(false)
                case .failure(let error):
                    errorPublisher.send(error)
                    loadingPublisher.send(false)
                }
            }, receiveCancel: {
                loadingPublisher.send(false)
            }, receiveRequest: { _ in
                loadingPublisher.send(true)
            })
    }
}
