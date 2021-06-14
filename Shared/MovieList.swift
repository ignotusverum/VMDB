//
//  CMovieList.swift
//  Shared
//
//  Created by Vlad Z. on 6/13/21.
//

import SwiftUI

extension Movie: Identifiable { }

struct MovieList: View {
    @State var movies: [Movie] = []

    var body: some View {
        List {
            ForEach(movies) { movie in
                VStack {
                    AsyncImage(url: movie.thumbnailURL,
                               placeholder: { ProgressView() },
                               image: { uiimage in
                        Image(uiImage: uiimage)
                            .resizable()
                    })
                        .mask(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal,
                                 80)
                    Text(movie.title)
                }
                .listRowSeparator(.hidden)
                .padding(.bottom,
                         10)
            }
        }
        .listStyle(.plain)
        .task {
            do {
                movies = try await MovieAdapter.topRated()
            } catch {
                print("[DEBUG] - Error \(error.localizedDescription)")
            }
        }
//        .onAppear {
//           /// Completion handler
//            MovieAdapter.topRated { result in
//                switch result {
//                case .success(let movies):
//                    self.movies = movies
//                case .failure(let error):
//                    print("[DEBUG] - Error \(error.localizedDescription)")
//                }
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MovieList()
    }
}
