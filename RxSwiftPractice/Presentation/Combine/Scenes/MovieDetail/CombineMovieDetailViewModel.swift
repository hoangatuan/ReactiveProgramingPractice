//
//  CombineMovieDetailViewModel.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 04/01/2023.
//

import Foundation
import Combine

final class CombineMovieDetailViewModel: BaseViewModel {
    private let useCase: ISearchMovieUseCase
    private let movieId: String
    private let loadingPublisher = PassthroughSubject<Bool, Never>()
    private let errorPublisher = PassthroughSubject<Error, Never>()
    let stepper = PassthroughSubject<Step, Never>()

    init(movieId: String, useCase: ISearchMovieUseCase) {
        self.movieId = movieId
        self.useCase = useCase
    }

    struct Output {
        let isLoading: AnyPublisher<Bool, Never>
        let onError: AnyPublisher<Error, Never>
        let movieDetail: AnyPublisher<MovieDetail, Never>
        let goBack: AnyPublisher<Void, Never>
    }

    struct Input {
        let tapBackButton: AnyPublisher<Void, Never>
    }

    func transform(input: Input) -> Output {
        let goBack = input.tapBackButton.handleEvents(receiveOutput: { [weak stepper] in
            stepper?.send(.goBack)
        }).eraseToAnyPublisher()

        let movieDetail = fetchMovieDetail(id: movieId)
            .handleLoadingAndError(loadingPublisher: loadingPublisher, errorPublisher: errorPublisher)
            .catch({ _ in Empty<MovieDetail, Never>() })
            .eraseToAnyPublisher()

        return Output(
            isLoading: loadingPublisher.eraseToAnyPublisher(),
            onError: errorPublisher.eraseToAnyPublisher(),
            movieDetail: movieDetail,
            goBack: goBack
        )
    }

    private func fetchMovieDetail(id: String) -> Future<MovieDetail, DBError> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(DBError.genericError))
                return
            }

            self.useCase.movieDetails(id: id, onCompletion: {
                promise(.success($0))
            }, onError: { _ in
                promise(.failure(DBError.genericError))
            })
        }
    }
}
