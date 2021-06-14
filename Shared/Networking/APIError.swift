//
//  APIError.swift
//  VMDB
//
//  Created by Vlad Z. on 6/13/21.
//

import Foundation

public protocol AppError: Error {
    var description: String { get }
}

public enum MovieError: AppError {
    case missingThumbnail

    public var description: String {
        switch self {
        case .missingThumbnail: return "Missing thumbnail"
        }
    }
}

public enum ApiErrorType: AppError {
    case commonError, serverError, parseError

    public var description: String {
        switch self {
        case .parseError: return "Parse Error"
        case .serverError: return "Server Error"
        case .commonError: return "Common API error"
        }
    }
}
