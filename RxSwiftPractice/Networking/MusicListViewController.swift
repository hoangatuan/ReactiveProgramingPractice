//
//  MusicListViewController.swift
//  RxSwiftPractice
//
//  Created by Digilife on 13/06/2021.
//

import UIKit
import RxSwift

/*
 
 */

final class Music: Codable {
    var artistName: String
    var id: String
    var releaseDate: String
    var name: String
    var copyright: String
    var artworkUrl100: String
}

struct MusicResults: Codable {
  var results: [Music]
}

struct FeedResults: Codable {
  var feed: MusicResults
}

class MusicListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let urlMusic = "https://rss.itunes.apple.com/api/v1/us/itunes-music/new-music/all/100/explicit.json"
    private let bag = DisposeBag()
        private var musics: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    // MARK: - Private Methods
    private func configUI() {
        title = "New Music"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadAPI() {
        Observable<String>.of(urlMusic)
            .map({ return URL(string: $0)! })
            .map({ return URLRequest(url: $0 )})
            .flatMap({ request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            })
            .filter({ response, data in
                return 200..<300 ~= response.statusCode
            }).map({ response, data in
                return data
            }).map({ data -> [Music] in
                let results = try? JSONDecoder().decode(FeedResults.self, from: data)
                return results?.feed.results ?? []
            }).share(replay: 1, scope: .forever)
            .subscribe(onNext: { data in
                debugPrint("Tuanha24: Receive resposne at time: \(Date().timeIntervalSince1970)")
                DispatchQueue.main.async {
                    self.musics = data
                    self.tableView.reloadData()
                }
            }).disposed(by: bag)
    }
    
    @IBAction func didTapButtonLoad(_ sender: Any) {
        debugPrint("Tuanha24: Did tap load at time: \(Date().timeIntervalSince1970)")
        loadAPI()
    }
    
    @IBAction func didTapButtonReload(_ sender: Any) {
        debugPrint("Tuanha24: Did tap reload at time: \(Date().timeIntervalSince1970)")
        loadAPI()
    }
}

extension MusicListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = musics[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.artistName
        return cell
    }
}

extension MusicListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
