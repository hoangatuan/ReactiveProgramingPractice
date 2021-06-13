//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by Digilife on 12/06/2021.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var registerButon: UIButton!
    
    // MARK: - Properties
    private var avatarIndex = 0
    private let bag = DisposeBag()
    private let imageRelay = BehaviorRelay<UIImage?>(value: nil)
    
    // MARK: Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        
        configUI()
        observe()
    }
    
    func configUI() {
        avatarImageView.layer.cornerRadius = 60.0
        avatarImageView.layer.borderWidth = 5.0
        avatarImageView.layer.borderColor = UIColor.gray.cgColor
        avatarImageView.layer.masksToBounds = true
        avatarImageView.contentMode = .scaleToFill
        
        let leftBarButton = UIBarButtonItem(title: "Change Avatar", style: .plain, target: self, action: #selector(self.changeAvatar))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func test_Register() {
        let viewModel = DemoViewModel()
//        viewModel.register(username: usernameTextfield.text, password: passwordTextfield.text, email: emailTextfield.text)
//            .subscribe(onNext: { debugPrint($0) },
//                       onError: { debugPrint("Error: \($0)")},
//                       onCompleted: {debugPrint("Complete")},
//                       onDisposed: {debugPrint("Disposed")})
//            .disposed(by: bag)
        
        viewModel.registerWithTrait(username: usernameTextfield.text, password: passwordTextfield.text, email: emailTextfield.text)
            .subscribe(onCompleted: { debugPrint("Complete") }, onError: { debugPrint("Error: \($0)") })
            .disposed(by: bag)
    }
    
    private func observe() {
        imageRelay.subscribe { [weak self] image in
            self?.avatarImageView.image = image
        }.disposed(by: bag)
    }
    
    @IBAction func didTapRegister(_ sender: Any) {
        test_Register()
    }
    
    @IBAction func didTapButtonClear(_ sender: Any) {
        
    }
    
    @objc func changeAvatar() {
        imageRelay.accept(UIImage(named: "avatar"))
    }
    
    private func showChooseImageView() {
        let vc2 = ChangeAvatarViewController()
        vc2.selectedPhotos.subscribe { image in
            debugPrint("Image")
        } onCompleted: {
            debugPrint("Completed")
        } onDisposed: {
            debugPrint("Disposed") // -> NOTE: Must call onComplete in VC2, because VC1's bag hold this subcription and never terminate -> Subcribe 4ever
        }.disposed(by: bag)
    }
}

