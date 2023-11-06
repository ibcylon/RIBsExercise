//
//  File.swift
//  
//
//  Created by Kanghos on 2023/11/06.
//

import Foundation
import ModernRIBs

public protocol FinanceHomeBuildable: Buildable {
  func build(withListener listener: FinanceHomeListener) -> ViewableRouting
}

public protocol FinanceHomeListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}
