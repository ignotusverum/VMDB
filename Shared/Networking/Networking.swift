//
//  Networking.swift
//  VMDB
//
//  Created by Vlad Z. on 6/13/21.
//

import Foundation

class Networking {
    static let shared = Networking()
    
    func request(for type: RequestType,
                 completion: @escaping (Result<Data, Error>)-> Void) {
        let request = configureURLRequest(for: type)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(.failure(ApiErrorType.serverError))
            } else {
                guard let data = data else {
                    completion(.failure(ApiErrorType.commonError))
                    return
                }
                completion(.success(data))
            }
        }
        task.resume()
    }
    
    func request(for type: RequestType) async throws -> Data {
        let request = configureURLRequest(for: type)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ApiErrorType.serverError }
        return data
    }
    
    private func configureURLRequest(for type: RequestType) -> URLRequest {
        let path = type.path
        var components = URLComponents(string: path)!
        components.queryItems = [.init(name: "api_key",
                                       value: "a3fa460eaba55bc312bc3ea75443c220")]
        components.queryItems?.append(contentsOf: type.queryItems)

        return URLRequest(url: components.url!)
    }
}

enum RequestType {
    case topRatedPage(Int)
    case thumbnail(String)
    
    var path: String {
        switch self {
        case .topRatedPage:
            return "https://api.themoviedb.org/3/movie/now_playing"
        case .thumbnail(let path):
            return "https://image.tmdb.org/t/p/\(path)"
        }
    }

    var queryItems: [URLQueryItem] {
        guard case .topRatedPage(let page) = self else { return [] }
        return [.init(name: "page",
                      value: "\(page)")]
    }
}
