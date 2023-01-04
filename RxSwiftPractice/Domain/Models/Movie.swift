//
//  Movie.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 03/01/2023.
//

import Foundation

struct Movie {
    let imdbID: String
    let title: String
    let year: String
    let poster: URL?
}

struct MovieDetail {
    let imdbID: String
    let title: String
    let year: String
    let rated: String
    let released: String
    let runTime: String
    let genre: String
    let type: String
    let poster: String
    let actors: String
    let imdbRating: String
    let imdbVotes: String
}
