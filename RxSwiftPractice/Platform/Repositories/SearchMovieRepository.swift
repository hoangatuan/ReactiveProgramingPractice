//
//  SearchMovieRepository.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 03/01/2023.
//

import Foundation

struct MovieSearchEndpoint: EndpointType {
    init(title: String) {
        urlParameters = ["title": title]
    }

    var baseURL: URL? {
        return URL(string: "https://imdb-api.com/")
    }

    var path: String {
        return "API/AdvancedSearch/k_nlwfp2n4/"
    }

    var method: HTTPMethod = .get

    var urlParameters: [String : String]?

    var bodyParameters: [String : String]? = nil

    var headers: [String : String]? = nil
}

struct MovieMapper: Mappable {
    func map(input: SearchMovieResponse) -> [Movie] {
        return input.search.map {
            Movie(imdbID: $0.imdbID, title: $0.title, year: $0.year, poster: URL(string: $0.poster))
        }
    }
}

struct MovieDetailMapper: Mappable {
    func map(input: MovieDetailDTO) -> MovieDetail {
        MovieDetail(
            imdbID: input.imdbID,
            title: input.title,
            year: input.year,
            rated: input.rated,
            released: input.released,
            runTime: input.runtime,
            genre: input.genre,
            type: input.type,
            poster: input.poster,
            actors: input.actors,
            imdbRating: input.imdbRating,
            imdbVotes: input.imdbVotes
        )
    }
}

final class SearchMovieRepository: NSObject, ISearchMovieRepository {
//    private let apiClientService: APIClientService
//
//    init(apiClientService: APIClientService) {
//        self.apiClientService = apiClientService
//    }

    // TODO: Inject APIClientServicec
    func search(input: SearchMovieInput, onCompletion: @escaping ([Movie]) -> Void, onError: @escaping (Error) -> Void) {
        guard let url = URL(string: "http://www.omdbapi.com/?apikey=f88c806c&s=\(input.title)") else {
            onError(DBError.genericError)
            return
        }

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

        session.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data else {
                onError(DBError.genericError)
                return
            }

            do {
                let response = try JSONDecoder().decode(SearchMovieResponse.self, from: data)
                onCompletion(MovieMapper().map(input: response))
            } catch {
                onError(DBError.genericError)
            }
        }.resume()
    }

    func movieDetails(id: String, onCompletion: @escaping (MovieDetail) -> Void, onError: @escaping (Error) -> Void) {
        guard let url = URL(string: "http://www.omdbapi.com/?apikey=f88c806c&i=\(id)") else {
            onError(DBError.genericError)
            return
        }

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

        session.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data else {
                onError(DBError.genericError)
                return
            }

            do {
                let response = try JSONDecoder().decode(MovieDetailDTO.self, from: data)
                onCompletion(MovieDetailMapper().map(input: response))
            } catch {
                onError(DBError.genericError)
            }
        }.resume()
    }
}

extension SearchMovieRepository: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let serverTrust = challenge.protectionSpace.serverTrust
        let credential = URLCredential(trust: serverTrust!)

        completionHandler(.useCredential, credential)
    }
}
