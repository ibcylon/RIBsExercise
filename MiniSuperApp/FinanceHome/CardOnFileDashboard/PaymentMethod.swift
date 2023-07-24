//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import Foundation

struct PaymentMethod: Decodable {
  let id: String
  let name: String
  let digits: String
  let color: String
  let isPrimary: Bool
} 
