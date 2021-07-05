//
//  TableView+CocoaAdvance.swift
//  RxSwiftPractice
//
//  Created by Digilife on 05/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

/*
 Refer: https://github.com/RxSwiftCommunity/RxDataSources
 */

struct Song {
    let name: String
    let author: String
}

struct SongSection: SectionModelType {
    var header: String
    var items: [Item]
}

extension SongSection {
    typealias Item = Song
    
    init(original: SongSection, items: [Song]) {
        self = original
        self.items = items
    }
}

class CocoaAdvanceTableView: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    let sections = Observable<[SongSection]>.of([SongSection(header: "Section 1 - Tac gia",
                                                             items: [Song(name: "Viet nam dieu ki", author: "Phuc du, GDucky, Hieuthuhai"),
                                                                     Song(name: "Loi cam on", author: "Tlinh"),
                                                                     Song(name: "Chuong 2", author: "MCK")]),
                                                 
                                                 SongSection(header: "Section 2 - Ten bai hat",
                                                             items: [Song(name: "Harder", author: "Wrxdie"),
                                                                     Song(name: "WhistList", author: "Wrxdie"),
                                                                     Song(name: "Gai Doc than", author: "Tlinh")])])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        sections.bind(to: tableView.rx.items(dataSource: createDatasource())).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: {
            print("on next: \($0)")
        }).disposed(by: disposeBag)

    }
    
    func createDatasource() -> RxTableViewSectionedReloadDataSource<SongSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<SongSection> { dataSource, tableView, indexpath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexpath)
            if indexpath.section == 0 {
                cell.textLabel?.text = item.author
            } else {
                cell.textLabel?.text = item.name
            }
            
            return cell
        }
        
        dataSource.titleForHeaderInSection = { section, index in
            return section[index].header
        }
        
        return dataSource
    }
}
