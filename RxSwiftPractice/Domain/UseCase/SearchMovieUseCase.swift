//
//  MovieUseCase.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 03/01/2023.
//

import Foundation

struct SearchMovieInput {
    let title: String
}

protocol ISearchMovieUseCase {
    func search(input: SearchMovieInput, onCompletion: @escaping ([Movie]) -> Void, onError: @escaping (Error) -> Void)
    func movieDetails(id: String, onCompletion: @escaping (MovieDetail) -> Void, onError: @escaping (Error) -> Void)
}

final class SearchMovieUseCase: ISearchMovieUseCase {
    private let repository: ISearchMovieRepository

    init(repository: ISearchMovieRepository) {
        self.repository = repository
    }

    func search(input: SearchMovieInput, onCompletion: @escaping ([Movie]) -> Void, onError: @escaping (Error) -> Void) {
        repository.search(input: input, onCompletion: onCompletion, onError: onError)
    }

    func movieDetails(id: String, onCompletion: @escaping (MovieDetail) -> Void, onError: @escaping (Error) -> Void) {
        repository.movieDetails(id: id, onCompletion: onCompletion, onError: onError)
    }
}
