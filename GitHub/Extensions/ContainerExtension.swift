//
//  ContainerExtension.swift
//  GitHub
//
//  Created by Le Chris on 21.06.2023.
//

import Foundation
import Swinject

extension Container {
    static var shared: Container = {
        let container = Container()
        return container
    }()
}
