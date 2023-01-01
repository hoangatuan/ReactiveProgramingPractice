//
//  SupportCode.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 01/01/2023.
//

import Foundation

public func example(of description: String,
                    action: () -> Void) {
  print("\n——— Example of:", description, "———")
  action()
}
