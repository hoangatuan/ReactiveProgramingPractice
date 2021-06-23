//
//  RxCocoaTraitDemoVC.swift
//  RxSwiftPractice
//
//  Created by Digilife on 14/06/2021.
//

import UIKit
import RxSwift
import RxCocoa

/*
 NOTE: Characteristic
 - Không có lỗi
 - observe và subscribe trên MainScheduler.
 - Có chia sẻ Side Effect ??
 
 Some types of Cocoa Trait:
 - Driver
 - Control Property = Observable + Property + Observer: Property which has value can be change by user interaction can emit value as an observable
 - Control Event = Observable: Event user make like tap, did end ...
 */

class RxCocoaTraitDemoVC: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var control: UISwitch!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTextFieldToControl()
        bindingMultipleControlEvent()
    }
    
    private func bindTextFieldToControl() {
//        textField.rx.text.map({ ($0 ?? "").count % 2 == 0 })
//            .bind(to: control.rx.isOn)
//            .disposed(by: bag)
        
        textField.rx.controlEvent(.editingDidEnd)
            .map({ (self.textField.text ?? "").count % 2 == 0 })
            .bind(to: control.rx.isOn)
            .disposed(by: bag)
    }
    
    private func bindingMultipleControlEvent() {
        let searchText = textField2.rx.controlEvent(.editingDidEnd)
            .map{( self.textField2.text ?? "")}
            .filter({ !$0.isEmpty })
        
        let search = searchText.flatMap({ _ in return self.fakeRequestAPI() })
        
        let loading = Observable.merge(searchText.map({ _ in true }), search.map({ _ in false })).share(replay: 1)
        
        loading
            .startWith(false) // NOTE: Emit event immediatly, emit this only
            .map({ !$0 })
            .bind(to: indicator.rx.isHidden)
            .disposed(by: bag)
        
        loading
            .bind(to: indicator.rx.isAnimating)
            .disposed(by: bag)
        
        loading
            .bind(to: textField.rx.isHidden)
            .disposed(by: bag)
        
        loading
            .bind(to: label.rx.isHidden)
            .disposed(by: bag)
        
        loading
            .bind(to: button.rx.isHidden)
            .disposed(by: bag)
        
        loading
            .bind(to: control.rx.isHidden)
            .disposed(by: bag)

    }
    
    private func fakeRequestAPI() -> Observable<Bool> {
        return Observable.create { observer in
            debugPrint("CALLLL")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                debugPrint("Finish")
                observer.onNext(true)
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
    
    
}
