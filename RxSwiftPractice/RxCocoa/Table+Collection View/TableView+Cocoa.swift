//
//  CollectionView+Cocoa.swift
//  RxSwiftPractice
//
//  Created by Digilife on 05/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

/* NOTE:
 - model stand point => can use if your table view base on list of models
 - Some special observable rxcocoa gives:
    + modelSelected(_:), modelDeselected(_:), itemSelected, itemDeselected
    + itemInserted, itemDeleted, itemMoved
    + willDisplayCell, didEndDisplayingCel
 
 - To set delegate, datasource to more customize: rx.setDelegate, rx.setDatasource
 */


struct Book {
    let name: String
    let auther: String
}

class CocoaTableView: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    let disposeBag = DisposeBag()
    
    let outDatas = Observable<[Book]>.of([Book(name: "Hoang tu be", auther: "Vu"),
                                       Book(name: "Are you ready", auther: "Lukas"),
                                       Book(name: "Gai Doc than", auther: "Tlinh")])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        outDatas.bind(to: myTableView.rx.items) { tableView, index, element in
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = element.auther
            cell.accessibilityLabel = element.name
            return cell
        }.disposed(by: disposeBag)
        
        myTableView.rx.modelSelected(Book.self).subscribe(onNext: {
            print("Select: \($0.name)")
        }).disposed(by: disposeBag)
        
        myTableView.rx.modelDeselected(Book.self).subscribe(onNext: {
            print("Deselect: \($0.name)")
        }).disposed(by: disposeBag)
        
        myTableView.rx.itemSelected.subscribe(onNext: {
            print("Select indexpath: \($0.item)")
        }).disposed(by: disposeBag)
        
        myTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension CocoaTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
