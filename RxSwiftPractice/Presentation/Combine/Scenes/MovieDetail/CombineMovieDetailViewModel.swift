//
//  CombineMovieDetailViewModel.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 04/01/2023.
//

import Foundation
import Combine

final class CombineMovieDetailViewModel {
    private let useCase: ISearchMovieUseCase
    private let movieId: String

    init(movieId: String, useCase: ISearchMovieUseCase) {
        self.movieId = movieId
        self.useCase = useCase
    }

    struct Output {
        let movieDetail: AnyPublisher<MovieDetail, Never>
    }

    func transform() -> Output {
        let movieDetail = fetchMovieDetail(id: movieId)
            .catch({ _ in Empty<MovieDetail, Never>() })
            .eraseToAnyPublisher()

        return Output(
            movieDetail: movieDetail
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
