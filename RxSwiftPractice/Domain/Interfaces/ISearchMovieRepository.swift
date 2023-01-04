//
//  ISearchMovieRepository.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 03/01/2023.
//

import Foundation

protocol ISearchMovieRepository: NSObject {
    func search(input: SearchMovieInput, onCompletion: @escaping ([Movie]) -> Void, onError: @escaping (Error) -> Void)
    func movieDetails(id: String, onCompletion: @escaping (MovieDetail) -> Void, onError: @escaping (Error) -> Void)
}
