//
//  Movie.swift
//  VMDB
//
//  Created by Vlad Z. on 6/13/21.
//

import Foundation
import UIKit
import SwiftUI

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let popularity: Double
    let releaseDate: Date?
    let voteAverage: Double
    let voteCount: Int
}

struct MoviePage: Decodable {
    let page: Int
    let results: [Movie]
}

extension Movie {
    var thumbnailURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}
