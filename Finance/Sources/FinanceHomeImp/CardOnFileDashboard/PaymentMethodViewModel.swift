//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import UIKit
import FinanceEntity

struct PaymentMethodViewModel {
  let id: String
  let name: String
  let digits: String
  let color: UIColor

  init(_ method: PaymentMethod) {
    self.id = method.id
    self.name = method.name
    self.color = UIColor(hex: method.color) ?? .systemGray2
    self.digits = "**** \(method.digits)"
  }
}
