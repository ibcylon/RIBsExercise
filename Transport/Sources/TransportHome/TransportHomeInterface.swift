//
//  File.swift
//  
//
//  Created by Kanghos on 2023/11/06.
//

import ModernRIBs

public protocol TransportHomeBuildable: Buildable {
  func build(withListener listener: TransportHomeListener) -> ViewableRouting
}

public protocol TransportHomeListener: AnyObject {
  func transportHomeDidTapClose()
}
