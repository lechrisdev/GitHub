//
//  MainViewModel.swift
//  GitHub
//
//  Created by Le Chris on 21.06.2023.
//

import Foundation

class MainViewModel: ObservableObject {
    
    @Published var users: [UserModel] = []
    @Published var isLoading: Bool = false
    
    private let repo: RepositoryProtocol
    let router: Router

    init(repo: RepositoryProtocol, router: Router) {
        self.repo = repo
        self.router = router
        DispatchQueue.main.async {
            Task {
                self.users = await repo.getUsers(lastUserId: 0, firstLoad: true)
            }
        }
        
    }
    
    @MainActor
    func loadUsersIfNeeded(index: Int) async {
        if index == users.count-5 {
            let lastUserId = users.last?.id ?? 0
            isLoading = true
            let newUsers = await repo.getUsers(lastUserId: lastUserId, firstLoad: false)
            users += newUsers
            isLoading = false
        }
    }
}
