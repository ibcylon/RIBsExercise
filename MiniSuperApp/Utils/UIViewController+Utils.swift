//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/26.
//

import UIKit

enum DismissButtonType: String {
  case back, close

  var iconSystemName: String {
    switch self {
    case .back:
      return "chevron.backward"
    case .close:
      return "xmark"
    }
  }
}

extension UIViewController {
  func setupNavigationItem(with buttonType: DismissButtonType, target: Any?, action: Selector?) {
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: buttonType.iconSystemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold))
      ,
      style: .plain,
      target: target,
      action: action
    )
  }
}
