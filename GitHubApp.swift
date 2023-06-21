//
//  GitHubApp.swift
//  GitHub
//
//  Created by Le Chris on 20.06.2023.
//

import SwiftUI
import Swinject

@main
struct GitHubApp: App {
    var body: some Scene {
        WindowGroup {
            EmptyView()
                .onAppear {
                    _ = Assembler([AppAssembly()],
                                  container: Container.shared)
                    Container.shared.resolve(Router.self)!.configureNavigationController()
                }
        }
    }
}

