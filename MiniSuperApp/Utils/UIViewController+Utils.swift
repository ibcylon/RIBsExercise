//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/26.
//

import UIKit

extension UIViewController {
  func setupNavigationItem(target: Any?, action: Selector?) {
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold))
      ,
      style: .plain,
      target: target,
      action: action
    )
  }
}
