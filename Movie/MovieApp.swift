//
//  MovieApp.swift
//  Movie
//
//  Created by Simona Ettari on 02/06/23.
//

import SwiftUI

@main
struct MovieApp: App {
    let viewModel = MoviesViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MoviesView()
                    .environmentObject(viewModel)
            }
        }
    }
}
