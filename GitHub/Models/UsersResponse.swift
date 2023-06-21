//
//  UsersResponse.swift
//  GitHub
//
//  Created by Le Chris on 21.06.2023.
//

import Foundation

// MARK: - UsersResponseElement
struct UsersResponseElement: Codable {
    let login: String
    let id: Int
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarURL = "avatar_url"
    }
}

enum TypeEnum: String, Codable {
    case organization = "Organization"
    case user = "User"
}

typealias UsersResponse = [UsersResponseElement]

extension UsersResponse {
    var domain: [UserModel] {
        self.map {
            UserModel(id: $0.id, avatarURL: $0.avatarURL, name: $0.login)
        }
    }
}
