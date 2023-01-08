//
//  CombineMovieDetailViewController.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 04/01/2023.
//

import Foundation
import UIKit
import Combine

final class CombineMovieDetailViewController: UIViewController {

    private let viewModel: CombineMovieDetailViewModel
    private var cancellables: [AnyCancellable] = []
    private let tapBackButton = PassthroughSubject<Void, Never>()

    init(viewModel: CombineMovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private let imageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFill
    }

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let ratingLabel = UILabel()
    private let actorsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupViews()
        setupBinding()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            tapBackButton.send(())
        }
    }

    private func setupViews() {
        view.addSubviews(views: imageView, titleLabel, descriptionLabel, ratingLabel, actorsLabel)

        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        actorsLabel.snp.makeConstraints {
            $0.top.equalTo(ratingLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
    }

    private func setupBinding() {
        let output = viewModel.transform(
            input: .init(tapBackButton: tapBackButton.eraseToAnyPublisher())
        )

        output.movieDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movieDetail in

                //TODO: ADd logic load image
                self?.titleLabel.text = movieDetail.title
                self?.descriptionLabel.text = "aaa"
                self?.ratingLabel.text = movieDetail.imdbRating
                self?.actorsLabel.text = movieDetail.actors
            }.store(in: &cancellables)

        output.goBack.sink(receiveValue: { }).store(in: &cancellables)

        output.isLoading.sink { isLoading in
            debugPrint("Show loading: \(isLoading)")
        }.store(in: &cancellables)

        output.onError.sink { error in
            debugPrint("Show error: \(error)")
        }.store(in: &cancellables)
    }
}
