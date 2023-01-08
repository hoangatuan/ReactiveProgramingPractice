//
//  CombineMovieSearchViewModel.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 03/01/2023.
//

import Foundation
import Combine

final class CombineMovieSearchViewModel: BaseViewModel {
    struct Input {
        let textDidChange: AnyPublisher<String, Never>
        let selectMovie: AnyPublisher<String, Never>
    }

    struct Output {
        let isLoading: AnyPublisher<Bool, Never>
        let onError: AnyPublisher<Error, Never>
        let listMovies: AnyPublisher<[Movie], Never>
        let navigateToMovieDetail: AnyPublisher<Void, Never>
    }

    private let useCase: ISearchMovieUseCase
    private let loadingPublisher = PassthroughSubject<Bool, Never>()
    private let errorPublisher = PassthroughSubject<Error, Never>()
    let stepper = PassthroughSubject<Step, Never>()

    init(useCase: ISearchMovieUseCase) {
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        let navigateToMovieDetail = input.selectMovie.handleEvents(receiveOutput: { [weak stepper] in
            stepper?.send(.moveToMovieDetail(id: $0))
        })
            .map { _ in }
            .eraseToAnyPublisher()

        let listMovies = input.textDidChange
            .map { [weak self] input -> AnyPublisher<[Movie], Never> in
                guard let self = self else { return Just<[Movie]>([]).eraseToAnyPublisher() }
                return self.fetchListMovie(title: input)
                    .handleLoadingAndError(loadingPublisher: self.loadingPublisher, errorPublisher: self.errorPublisher)
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
            }.switchToLatest()
            .eraseToAnyPublisher()
        
        return Output(
            isLoading: loadingPublisher.eraseToAnyPublisher(),
            onError: errorPublisher.eraseToAnyPublisher(),
            listMovies: listMovies,
            navigateToMovieDetail: navigateToMovieDetail
        )
    }

    private func fetchListMovie(title: String) -> Future<[Movie], Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(DBError.genericError))
                return
            }

            self.useCase.search(input: .init(title: title), onCompletion: {
                promise(.success($0))
            }, onError: {
                promise(.failure($0))
            })
        }
    }
}
