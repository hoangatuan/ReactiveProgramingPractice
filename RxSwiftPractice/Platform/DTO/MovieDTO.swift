//
//  MovieDTO.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 03/01/2023.
//

import Foundation

struct SearchMovieResponse: Decodable {
    let search: [MovieDTO]

    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

struct MovieDTO: Decodable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
