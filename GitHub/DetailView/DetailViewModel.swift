//
//  DetailViewModel.swift
//  GitHub
//
//  Created by Le Chris on 21.06.2023.
//

import Foundation

class DetailViewModel: ObservableObject {
    
    @Published var userRepositories: [RepoModel] = []
    @Published var isLoading: Bool = false
    
    let user: String
    private var page: Int = 2
    let avatarURL: String
    private var lastIndex: Int = 0
    
    let repo: RepositoryProtocol
    let router: Router
    
    init(repo: RepositoryProtocol, router: Router, user: String, avatarURL: String) {
        self.repo = repo
        self.router = router
        self.user = user
        self.avatarURL = avatarURL
        DispatchQueue.main.async {
            Task {
                self.userRepositories = await repo.getUserRepositories(userName: user,
                                                                       page: 1,
                                                                       firstLoad: true)
            }
        }
    }
    
    @MainActor
    func loadUserRepos(index: Int) async {
        if index == userRepositories.count-5 {
            isLoading = true
            userRepositories += await repo.getUserRepositories(userName: user,
                                                               page: page,
                                                               firstLoad: false)
            page += 1
            isLoading = false
        }
    }
}


