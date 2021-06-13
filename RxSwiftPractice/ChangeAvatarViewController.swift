//
//  ChangeAvatarViewController.swift
//  RxSwiftPractice
//
//  Created by Digilife on 13/06/2021.
//

import UIKit
import RxCocoa
import RxSwift

/*
 Ref: https://fxstudio.dev/rxswift-vs-uikit-tuong-tac-giua-cac-viewcontroller/
 
 */

class ChangeAvatarViewController: UIViewController {
    private let bag = DisposeBag()
    
    private let selectedPhotosSubject = PublishSubject<UIImage>() // NOTE: Make private to not allow emit element from outside
    
    var selectedPhotos: Observable<UIImage> { 
        return selectedPhotosSubject.asObservable()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectedPhotosSubject.onCompleted() // NOTE: Because this observable was hold in a rootView's bag -> it will never been disposed. Must call complete to terminate.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
