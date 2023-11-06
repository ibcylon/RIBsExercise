//
//  File.swift
//  
//
//  Created by Kanghos on 2023/11/06.
//

import Foundation
import ModernRIBs

public protocol TopupBuildable: Buildable {
  func build(withListener listener: TopupListener) -> Routing
}

public protocol TopupListener: AnyObject {
  func topupDidClose()
  func topupDidFinish()
}
