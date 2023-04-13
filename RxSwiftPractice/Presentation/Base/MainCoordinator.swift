//
//  Coordinator.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 05/01/2023.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get set }

    func start()
    func removeAllChildCoordinator()
    
    /// Need to call this function when finish to clean up memory
    func didFinish(child: Coordinator, metadata: [String: Any?]?)
}

class BaseCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    private(set) var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(parentCoordinator: Coordinator?, navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }

    deinit {
        print("Deinit Coordinator: \(self)")
    }

    func start() {
        fatalError("Must override this func")
    }

    func removeAllChildCoordinator() {
        childCoordinators = []
    }

    func didFinish(child: Coordinator, metadata: [String: Any?]? = nil) {
        child.removeAllChildCoordinator()
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
    }

    func coordinate(to coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

class MainCoordinator: BaseCoordinator {
    override func start() {
        let combineMovieSearchCoordinator = CombineMovieSearchCoordinator(parentCoordinator: self, navigationController: navigationController)
        coordinate(to: combineMovieSearchCoordinator)
    }
}
