//
//  CombineMovieSearchViewController.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 03/01/2023.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import RxDataSources

final class CombineMovieSearchViewController: UIViewController {
    private let viewModel: CombineMovieSearchViewModel
    private var cancellables: [AnyCancellable] = []
    private lazy var dataSource = makeDataSource()
    private let selectMovie = PassthroughSubject<String, Never>()

    init(viewModel: CombineMovieSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private let searchBar = UISearchBar()

    private let tableView = UITableView().configure {
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 182
        $0.backgroundColor = .clear
        $0.register(CombineMovieCell.self, forCellReuseIdentifier: "CombineMovieCell")
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupBinding()
    }

    private func setupViews() {
        view.addSubviews(views: searchBar, tableView)
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.trailing.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    private func setupBinding() {
        let output = viewModel.transform(
            input: .init(
                textDidChange: searchBar.searchTextField.textPublisher
                    .compactMap { $0 }
                    .removeDuplicates()
                    .throttle(for: 0.6, scheduler: DispatchQueue.main, latest: true)
                    .dropFirst()
                    .eraseToAnyPublisher(),
                selectMovie: selectMovie.eraseToAnyPublisher()
            )
        )

        output.listMovies.sink { [weak self] movies in
            self?.update(with: movies, animate: false)
        }.store(in: &cancellables)

        output.isLoading.sink { isLoading in
            debugPrint("Show loading: \(isLoading)")
        }.store(in: &cancellables)

        output.onError.sink { error in
            debugPrint("Show error: \(error)")
        }.store(in: &cancellables)

        output.navigateToMovieDetail.sink(receiveValue: { }).store(in: &cancellables)
    }
}

extension CombineMovieSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        tableView.deselectRow(at: indexPath, animated: true)

        selectMovie.send(snapshot.itemIdentifiers[indexPath.row].imdbID)
    }
}

private extension CombineMovieSearchViewController {
    enum Section: CaseIterable {
        case movies
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, Movie> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, movie in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CombineMovieCell") as? CombineMovieCell else {
                    assertionFailure("Failed to dequeue \(CombineMovieCell.self)!")
                    return UITableViewCell()
                }
                cell.bind(movie)
                return cell
            }
        )
    }

    func update(with movies: [Movie], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(movies, toSection: .movies)
        self.dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

extension Movie: Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.imdbID == rhs.imdbID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(imdbID)
    }
}
