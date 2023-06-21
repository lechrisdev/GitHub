//
//  RepoModel.swift
//  GitHub
//
//  Created by Le Chris on 21.06.2023.
//

import Foundation

struct RepoModel: Hashable {
    let id: Int
    let name: String
    let description: String?
    let stars: Int
    let language: String?
    let htmlURL: String
}
