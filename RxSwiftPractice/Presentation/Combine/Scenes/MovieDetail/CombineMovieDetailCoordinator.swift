//
//  CombineMovieDetailCoordinator.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 08/01/2023.
//

import UIKit
import Combine

final class CombineMovieDetailCoordinator: BaseCoordinator {
    var cancellables = [AnyCancellable]()
    private let movieID: String
    var viewController: UIViewController!

    init(movieID: String, navigationController: UINavigationController, parentCoordinator: Coordinator?) {
        self.movieID = movieID
        super.init(parentCoordinator: parentCoordinator, navigationController: navigationController)
    }

    override func start() {
        // TODO: Create DI Container
        let vm = CombineMovieDetailViewModel(movieId: movieID, useCase: SearchMovieUseCase(repository: SearchMovieRepository()))
        vm.stepper.sink { [weak self] step in
            self?.handleStep(step)
        }.store(in: &cancellables)

        let vc = CombineMovieDetailViewController(viewModel: vm)
        viewController = vc
        navigationController.pushViewController(vc, animated: true)
    }

    func handleStep(_ step: Step) {
        switch step {
        case .goBack:
            parentCoordinator?.didFinish(child: self, metadata: nil)
        default:
            break
        }
    }
}
