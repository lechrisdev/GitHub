//
//  AppAssembly.swift
//  GitHub
//
//  Created by Le Chris on 21.06.2023.
//

import Foundation
import Swinject

class AppAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: - Managers
        container.register(Router.self, factory: { _ in
            Router()
        })
        .inObjectScope(.container)
        
        container.register(Persistence.self) { _ in
            Persistence()
        }
        .inObjectScope(.container)
        
        container.register(Repository.self) { container in
            Repository(persistence: container.resolve(Persistence.self)!)
        }
        .inObjectScope(.container)
     
        // MARK: - ViewModels
        
        container.register(MainViewModel.self, factory: { container in
            MainViewModel(repo: container.resolve(Repository.self)!,
                          router: container.resolve(Router.self)!)
        })
        
        container.register(DetailViewModel.self, factory: { container, user, avatarURL in
            DetailViewModel(repo: container.resolve(Repository.self)!,
                            router: container.resolve(Router.self)!,
                            user: user,
                            avatarURL: avatarURL)
        })
    }
}
