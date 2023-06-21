//
//  Persistence.swift
//  GitHub
//
//  Created by Le Chris on 21.06.2023.
//

import Foundation
import CoreData

protocol PersistenceProtocol {
    func loadUsers() -> [UserModel]
    func loadUserRepositories(ownerName: String) -> [RepoModel]
    func saveUsers(users: [UserModel])
    func saveUserRepositories(repos: [RepoModel], userName: String)
}

class Persistence: PersistenceProtocol {
    
    private let model = "DataModel"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        return createContainer()
        
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return createContext()
    }()
    
    public init() {}
    
    // Read local data
    func loadUsers() -> [UserModel] {
        let request = CDUsers.fetchRequest()
        let result = try? context.fetch(request)
            .map {
                UserModel(id: Int($0.id),
                          avatarURL: $0.avatarURL ?? "",
                          name: $0.name ?? "")
            }
        return result ?? []
    }
    
    func loadUserRepositories(ownerName: String) -> [RepoModel] {
        
        let request = CDRepositories.fetchRequest()
        request.predicate = NSPredicate(format: "ownerName == %@", ownerName)
        
        do {
            let result = try context.fetch(request)
                .map {
                    RepoModel(id: Int($0.id),
                              name: $0.name ?? "",
                              description: $0.descript,
                              stars: Int($0.stars),
                              language: $0.language,
                              htmlURL: $0.htmlURL ?? "")
                }
            return result
        } catch {
            print("⛔️⛔️⛔️⛔️⛔️ Error fetching data from context \(error)")
        }
        return []
    }
    
    // Save to database
    func saveUsers(users: [UserModel]) {
        for user in users {
            let newUser = CDUsers(context: context)
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            newUser.name = user.name
            newUser.avatarURL = user.avatarURL
            newUser.id = Int64(user.id)
            
            do {
                try context.save()
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️ saving to core data", error)
            }
        }
    }
    
    func saveUserRepositories(repos: [RepoModel], userName: String) {
        
        for repo in repos {
            let newRepo = CDRepositories(context: context)
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            newRepo.name = repo.name
            newRepo.htmlURL = repo.htmlURL
            newRepo.language = repo.language
            newRepo.stars = Int64(repo.stars)
            newRepo.id = Int64(repo.id)
            newRepo.ownerName = userName
            newRepo.descript = repo.description
            
            do {
                try context.save()
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️ saving to core data", error)
            }
        }
        
    }
    
    func saveContext () {
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func createContainer() -> NSPersistentContainer {
        
        let container = NSPersistentContainer(name: model)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("⛔️⛔️⛔️⛔️⛔️ Unresolved error \(error), \(error.userInfo)")
            }
        })
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        return container
    }
    
    private func createContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }
}

