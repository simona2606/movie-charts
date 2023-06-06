//
//  MoviesView.swift
//  Movie
//
//  Created by Simona Ettari on 02/06/23.
//

import SwiftUI
import Charts

struct MoviesView: View {
    @EnvironmentObject var viewModel: MoviesViewModel
    
    var body: some View {
        TabView {
            List {
                Section(header: Text("Popular Movies")) {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailsView(movie: movie)) {
                            MovieCardView(movie: movie)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.getMovies()
            }
            .tabItem {
                Label("Movies", systemImage: "popcorn.fill")
            }
            ScrollView {
                Chart {
                    
                    // To be more clear I have considered only the first 15 elements
                    ForEach(viewModel.movieRatings.prefix(15)) { movie in
                        
                        // To represent rates with a line
                        //                        LineMark(x: .value("Movies", movie.title),
                        //                                 y: .value("Vote Average", movie.voteAverage))
                        //                        .foregroundStyle(Color.purple)
                        //                        .symbol(by: .value("Movie", movie.title))
                        //                        .accessibilityLabel(movie.title)
                        //                        .accessibilityValue("\(movie.voteCount) votes")
                        //                        .interpolationMethod(.catmullRom)
                        
                        //                        AreaMark(x: .value("Movies", movie.title), yStart: .value("Vote Min", movie.minVote()), yEnd: .value("Vote Max", movie.maxVote()))
                        //                                .opacity(0.3)
                        
                        RectangleMark(x: .value("Movies", movie.title), y: .value("Vote Average", movie.voteAverage), width: .ratio(0.6), height: 3)
                        
                        
                        BarMark(x: .value("Movies", movie.title),
                                yStart: .value("Vote Min", movie.minVote()),
                                yEnd: .value("Vote Max", movie.maxVote()))
                        .symbol(by: .value("Movie", movie.title))
                        .opacity(0.3)
                        
                        // To represent rates with points
                        //                        PointMark(x: .value("Movies", movie.title),
                        //                                y: .value("Vote Count", movie.voteCount))
                        
                        // To represent rates with bars
                        //                        BarMark(x: .value("Vote Count", movie.voteCount),
                        //                                y: .value("Movies", movie.title))
                        //                        .foregroundStyle(by: .value("Movie", movie.title))
                    }
                    .foregroundStyle(.gray.opacity(0.5))
                    
                    RuleMark(y: .value("Average", viewModel.getMovieRatingsVoteAverage()))
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        .annotation(position: .top, alignment: .leading) {
                            Text("Average \(viewModel.getMovieRatingsVoteAverage(), format: .number)")
                                .font(.italic(.body)())
                                .foregroundColor(.red)
                                .padding(.horizontal, 8)
                        }
                }
                .padding(.horizontal, 8)
                .chartYScale(domain: 0...35)
                .chartYAxis {
                    AxisMarks(preset: .extended, position: .leading)
                }
                
                //            .chartXAxis(.hidden)
                //            .chartYAxis(.hidden)
                
                .chartPlotStyle(content: { plotArea in
                    plotArea
                        .frame(height: 500)
                        .lineLimit(3)
                        .background(.pink.opacity(0.1))
                        .border(.blue, width: 1)
                })
            }
                .onAppear {
                    viewModel.getMovieRating()
                }
                .padding(15)
                .tabItem {
                    Label("Rating", systemImage: "chart.bar")
                }
            
        }
        .navigationTitle("Movies")
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
            .environmentObject(MoviesViewModel())
    }
}
