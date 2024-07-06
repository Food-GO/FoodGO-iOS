//
//  Coordinator.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}


