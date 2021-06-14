//
//  MovieAdapter.swift
//  VMDB
//
//  Created by Vlad Z. on 6/13/21.
//

import Foundation

class MovieAdapter {
    static func topRated(with page: Int = 1) async throws -> [Movie] {
        try await Networking
            .shared
            .request(for: .topRatedPage(page))
            .map(to: MoviePage.self)
            .results
    }

    static func topRated(with page: Int = 1,
                         completion: @escaping (Result<[Movie], Error>)-> Void) {
        Networking
            .shared
            .request(for: .topRatedPage(page),
                        completion: { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder.defaultDecoder
                    do {
                        let moviePage = try decoder.decode(MoviePage.self,
                                                           from: data)
                        completion(.success(moviePage.results))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }
}
