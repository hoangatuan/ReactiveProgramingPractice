//
//  CombineMovieSearchViewModel.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 03/01/2023.
//

import Foundation
import Combine

final class CombineMovieSearchViewModel {
    struct Input {
        let textDidChange: AnyPublisher<String, Never>
    }

    struct Output {
        let listMovies: AnyPublisher<[Movie], Never>
    }

    private let useCase: ISearchMovieUseCase
    init(useCase: ISearchMovieUseCase) {
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        // TODO: Handle Loading & error
        let listMovies = input.textDidChange
            .map { [weak self] input -> AnyPublisher<[Movie], Never> in
                guard let self = self else { return Just<[Movie]>([]).eraseToAnyPublisher() }
                return self.fetchListMovie(title: input)
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
            }.switchToLatest()
            .eraseToAnyPublisher()
        
        return Output(listMovies: listMovies)
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
