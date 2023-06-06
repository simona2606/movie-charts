//
//  MovieAPI.swift
//  Movie
//
//  Created by Simona Ettari on 02/06/23.
//

import Foundation
import Alamofire

typealias MovieAPIResponse = (Swift.Result<[Movie]?, DataError>) -> Void
typealias MovieRatingAPIResponse = (Swift.Result<[MovieRating]?, DataError>) -> Void

protocol MovieAPILogic {
    func getMovies(completion: @escaping (MovieAPIResponse))
    func getMovieRatings(completion: @escaping (MovieRatingAPIResponse))
}


class MovieAPI: MovieAPILogic {
    private struct Constants {
        static let apiKey = "9b94de2654d82e14b60d1cc6143665af"
        static let languageLocale = "en-US"
        
        static let moviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=\(languageLocale)&page=\(pageValue)"
        
        ///https://developer.themoviedb.org/reference/movie-top-rated-list
        static let movieRatingURL = "https://api.themoviedb.org/3//movie/top_rated?api_key=\(apiKey)&language=\(languageLocale)&page=\(pageValue)"
        
        static let pageValue = 1
        static let rParameter = "r"
        static let json = "json"
    }
    
    func getMovies(completion: @escaping (MovieAPIResponse)) {
        //This prevents AF retrieving cached response
        URLCache.shared.removeAllCachedResponses()
        
        AF.request(Constants.moviesURL, method: .get, encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: MovieRootResult.self) { response in
                switch response.result {
                case .failure(let error):
                    completion(.failure(.networkingError(error.localizedDescription)))
                case .success(let movieListResult):
                    completion(.success(movieListResult.movies))
                }
            }
    }
    
    func getMovieRatings(completion: @escaping (MovieRatingAPIResponse)) {
        URLCache.shared.removeAllCachedResponses()
        
        AF.request(Constants.movieRatingURL, method: .get, encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: TopRatedMovieRootResult.self) { response in
                switch response.result {
                case .failure(let error):
                    completion(.failure(.networkingError(error.localizedDescription)))
                case .success(let movieRatingResult):
                    completion(.success(movieRatingResult.topRatedMovies))
                }
            }
    }
    
}
