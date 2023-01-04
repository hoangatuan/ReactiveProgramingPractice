//
//  MovieDetailDTO.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 04/01/2023.
//

import Foundation

struct MovieDetailDTO: Decodable {
    let title: String
    let year: String
    let imdbID: String
    let rated: String
    let type: String
    let poster: String
    let released: String
    let runtime: String
    let genre: String
    let actors: String
    let imdbRating: String
    let imdbVotes: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case rated = "Rated"
        case type = "Type"
        case poster = "Poster"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case actors = "Actors"
        case imdbRating
        case imdbVotes
    }
}
