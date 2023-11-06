//
//  AdaptivePresentaionControllerDelegate.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import UIKit

// interacotr가 UIKit객체를 포함하는게 적절하지 않기 때문에 Wrap / Protocol
// 해서 Interactor가 사용하게 한다.
public protocol AdaptivePresentaionControllerDelegate: AnyObject {
  func presentationControllerDidDismiss()
}

public final class AdaptivePresentaionControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
  public weak var delegate: AdaptivePresentaionControllerDelegate?

  public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    delegate?.presentationControllerDidDismiss()
  }
}
