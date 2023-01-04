//
//  View+Extension.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 03/01/2023.
//

import UIKit

extension UIView {
    func addSubviews(views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

extension UIStackView {
    func addArrangeSubviews(views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
