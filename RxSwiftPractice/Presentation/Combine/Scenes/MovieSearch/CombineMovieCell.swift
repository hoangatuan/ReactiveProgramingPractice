//
//  CombineMovieCell.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 03/01/2023.
//

import UIKit
import Combine

final class CombineMovieCell: UITableViewCell {
    var downloadItem: AnyCancellable?

    // MARK: - UI
    private let movieImageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFit
    }

    private let movieNameLabel = UILabel()
    private let yearLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupViews()
    }

    override func prepareForReuse() {
        downloadItem?.cancel()
        downloadItem = nil
        super.prepareForReuse()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubviews(views: movieImageView, movieNameLabel, yearLabel)

        movieImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(16)
            $0.height.equalTo(150)
            $0.width.equalTo(100)
        }

        movieNameLabel.snp.makeConstraints {
            $0.leading.equalTo(movieImageView.snp.trailing).offset(16)
            $0.top.equalTo(movieImageView.snp.top)
            $0.trailing.equalToSuperview().inset(16)
        }

        yearLabel.snp.makeConstraints {
            $0.leading.equalTo(movieNameLabel.snp.leading)
            $0.top.equalTo(movieNameLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    func bind(_ movie: Movie) {
        movieNameLabel.text = movie.title
        yearLabel.text = movie.year

        // TODO: Can't reach poster url. Find a way to connect
        // TODO: implement caching
        // TODO: Inject downloading servicec
        
        if let url = movie.poster {
            downloadItem = fetchImage(url: URL(string: "https://imusic.b-cdn.net/images/item/original/821/5703239518821.jpg?pele-the-birth-of-a-legend-dvd&class=scaled")!)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in

                }, receiveValue: { [weak self] data in
                    guard let data = data else { return }
                    let image = UIImage(data: data)
                    self?.movieImageView.image = image
                })
        }

    }

    func fetchImage(url: URL) -> AnyPublisher<Data?, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
