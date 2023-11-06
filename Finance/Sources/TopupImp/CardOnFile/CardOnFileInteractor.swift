//
//  CardOnFileInteractor.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/26.
//

import ModernRIBs
import FinanceEntity
import AddPaymentMethod

protocol CardOnFileRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFilePresentable: Presentable {
  var listener: CardOnFilePresentableListener? { get set }

  func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileListener: AnyObject {
  func cardOnFileDidTapClose()
  func cardOnFileDidTapAddCard()
  func cardOnFileDidSelect(at index: Int)
}

final class CardOnFileInteractor: PresentableInteractor<CardOnFilePresentable>, CardOnFileInteractable, CardOnFilePresentableListener {

  weak var router: CardOnFileRouting?
  weak var listener: CardOnFileListener?

  private let paymentMethods: [PaymentMethod]

  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(presenter: CardOnFilePresentable, paymentMethods: [PaymentMethod]) {
    self.paymentMethods = paymentMethods
    super.init(presenter: presenter)
    presenter.listener = self
  }

  override func didBecomeActive() {
    super.didBecomeActive()

    let viewModels = self.paymentMethods.map(PaymentMethodViewModel.init)
    presenter.update(with: viewModels)
  }

  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }

  func didTapClose() {
    listener?.cardOnFileDidTapClose()
  }

  func didSelectItem(at index: Int) {
    if index >= paymentMethods.count {
      listener?.cardOnFileDidTapAddCard()
    } else {
      listener?.cardOnFileDidSelect(at: index)
    }
  }
}
