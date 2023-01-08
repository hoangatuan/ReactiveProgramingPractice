//
//  CombineMovieSearchCoordinator.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 05/01/2023.
//

import UIKit
import Combine

final class CombineMovieSearchCoordinator: BaseCoordinator {
    var cancellables = [AnyCancellable]()

    override func start() {
        // TODO: Create DI Container
        let viewModel = CombineMovieSearchViewModel(useCase: SearchMovieUseCase(repository: SearchMovieRepository()))
        let viewController = CombineMovieSearchViewController(viewModel: viewModel)

        viewModel.stepper.sink { [weak self] step in
            self?.handleNavigate(step)
        }.store(in: &cancellables)

        navigationController.pushViewController(viewController, animated: true)
    }

    private func handleNavigate(_ step: Step) {
        switch step {
        case .moveToMovieDetail(let id):
            let movieDetailCoordinator = CombineMovieDetailCoordinator(movieID: id, navigationController: navigationController, parentCoordinator: self)
            coordinate(to: movieDetailCoordinator)
        case .goBack:
            parentCoordinator?.didFinish(child: self, metadata: nil)
        }
    }

    private func didFinish() {
        parentCoordinator?.didFinish(child: self, metadata: nil)
    }
}
