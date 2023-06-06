//
//  MovieViewModel.swift
//  Movie
//
//  Created by Simona Ettari on 02/06/23.
//

import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var error: DataError? = nil
    @Published private(set) var movieRatings: [MovieRating] = []
    
    private let apiService: MovieAPILogic
    
    init(apiService: MovieAPILogic = MovieAPI()) {
        self.apiService = apiService
    }
    
    func getMovies() {
        apiService.getMovies() { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies ?? []
            case .failure(let error):
                self?.error = error
            }
        }
    }
    
    func getMovieRatingsVoteAverage() -> Double {
        let voteAverages = movieRatings.prefix(15).map { $0.voteAverage }
        let sum = voteAverages.reduce(0, +)
        return sum / 10
    }
    
    func getMovieRating() {
        apiService.getMovieRatings() { [weak self] result in
            switch result {
            case .success(let movieRatings):
                self?.movieRatings = movieRatings ?? []
            case .failure(let error):
                self?.error = error
            }
        }
    }
}
