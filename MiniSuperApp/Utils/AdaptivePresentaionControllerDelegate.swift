//
//  AdaptivePresentaionControllerDelegate.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import UIKit

// interacotr가 UIKit객체를 포함하는게 적절하지 않기 때문에 Wrap / Protocol
// 해서 Interactor가 사용하게 한다.
protocol AdaptivePresentaionControllerDelegate: AnyObject {
  func presentationControllerDidDismiss()
}

final class AdaptivePresentaionControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
  weak var delegate: AdaptivePresentaionControllerDelegate?

  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    delegate?.presentationControllerDidDismiss()
  }
}
