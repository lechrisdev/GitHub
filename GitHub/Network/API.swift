//
//  API.swift
//  GitHub
//
//  Created by Le Chris on 20.06.2023.
//

import Foundation
import Alamofire

class API {

    static func sendRequestData(request: EndPoint) async -> Data? {
        do {
            // TODO: Add GitHub token
            let token = "GITHUB TOKEN NEEDED"
            let headers: HTTPHeaders = ["Authorization": "token \(token)"]

            return try await AF.request(request.path,
                                        method: request.httpMethod,
                                        parameters: request.parameters,
                                        encoding: URLEncoding.default,
                                        headers: headers)
                    .validate(statusCode: 200..<300)
                    .serializingData()
                    .value
        } catch {
            print("Error sending request: \(error)")
            return nil
        }
    }
}

protocol EndPoint {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var parameters: Parameters? { get }
}

enum Requests: EndPoint {
    case getUsers(lastUserId: Int)
    case getUserRepositories(userName: String, page: Int)

    var path: String {
        switch self {
        case .getUsers:
            return "https://api.github.com/users"
        case let .getUserRepositories(userName, _):
            return "https://api.github.com/users/\(userName)/repos"
        }
    }

    var httpMethod: Alamofire.HTTPMethod {
        switch self {
        case .getUsers, .getUserRepositories:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .getUsers(lastUserId):
            let parameters: [String: Encodable] = [
                "per_page": 10,
                "since": lastUserId
            ]
            return parameters
        case let .getUserRepositories(_ , page):
            let parameters: [String: Encodable] = [
                "per_page": 10,
                "page": page
            ]
            return parameters
        }
    }
}
