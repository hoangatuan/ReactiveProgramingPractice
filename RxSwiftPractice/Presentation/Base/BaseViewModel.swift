//
//  BaseViewModel.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 05/01/2023.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
