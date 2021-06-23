//
//  RxCocoaDemoVC.swift
//  RxSwiftPractice
//
//  Created by Digilife on 14/06/2021.
//

import UIKit
import RxSwift
import RxCocoa

/* Note:
 - Binder has the same advantage as subcribe, but it is more convinience. Binder is the same as ObserverType, only receive event.
 - a button can have rx.tap and IBaction at the same time.
 - if set text property, must call sendActions(for: .valueChanged).
 
There are 2 ways to custom Binder
    - create a variable of type Binder inside object
    - create a variable of type Binder inside extension of Reactive -> I think we should do this because it more clear.
 */

class RxCocoaPlaygroundVC: UIViewController {
    let bag = DisposeBag()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var customView: CustomView!
    
    var myTitle: Binder<String?> {
        return Binder(self) { (vc, value) in
            vc.title = value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindLabelToTextfield()
        bindTextfieldToCustomViewLabel()
    }
    
    private func bindLabelToTextfield() {
        textField.rx.text.bind(to: label.rx.text)
            .disposed(by: bag)
        
        textField.rx.text.bind(to: myTitle).disposed(by: bag)
        
        textField.rx.controlEvent(.editingDidEnd).map({ return self.textField.text }).bind(to: button.rx.title()).disposed(by: bag)
    }
    
    private func bindTextfieldToCustomViewLabel() {
        textField.rx.text.bind(to: customView.label.rx.text).disposed(by: bag)
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        textField.text = "hello"
//
//        // NOTE: Must call this because Rxcocoa observe when value change. Programmatic value changes won't be reported.
//        // Refer: - https://stackoverflow.com/questions/33815399/rxswift-uilabel-field-not-being-updated-when-uitextfield-updated-programmatica
//        //        - ControlProperty.swift line 21-22.
//
        textField.sendActions(for: .valueChanged)
        
        /*
        button.rx.tap.map({ return "AAA" })
            .bind(to: textField.rx.text)
            .disposed(by: bag)
         */ // -> only make textfield update value, not label -> bind to is to set value change programmatic and dont notify value changes.
    }
}

extension Reactive where Base: RxCocoaPlaygroundVC {
    var myTitle: Binder<String?> {
        return Binder(self.base) { (vc, value) in
            vc.title = value
        }
    }
}
