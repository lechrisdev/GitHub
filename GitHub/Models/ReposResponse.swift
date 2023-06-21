//
//  ReposResponse.swift
//  GitHub
//
//  Created by Le Chris on 21.06.2023.
//

import Foundation

// MARK: - ReposResponseElement
struct ReposResponseElement: Codable {
    let id: Int
    let name: String
    let htmlURL: String
    let description: String?
    let stargazersCount: Int
    let language: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case htmlURL = "html_url"
        case description //, fork, url
        case stargazersCount = "stargazers_count"
        case language
    }
}

typealias ReposResponse = [ReposResponseElement]

extension ReposResponse {
    var domain: [RepoModel] {
        self.map {
            RepoModel(id: $0.id,
                      name: $0.name,
                      description: $0.description,
                      stars: $0.stargazersCount,
                      language: $0.language,
                      htmlURL: $0.htmlURL)
        }
    }
}
