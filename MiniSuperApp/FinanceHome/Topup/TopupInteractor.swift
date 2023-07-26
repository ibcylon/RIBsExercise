//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/26.
//

import ModernRIBs

protocol TopupRouting: Routing {
  func cleanupViews()
  func attachAddPaymentMethod()
  func detachAddPaymentMethod()
  func attachEnterAmount()
  func detachEnterAmount()
  func attachCardOnFile(paymentMethods: [PaymentMethod])
  func detachCardOnFile()
}

protocol TopupListener: AnyObject {
  func topupDidClose()
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentaionControllerDelegate {

  weak var router: TopupRouting?
  weak var listener: TopupListener?
  private let depedency: TopupInteractorDependency

  private var paymentMethods: [PaymentMethod] {
    depedency.cardOnFileRepository.cardOnFile.value
  }

  let presentationDelegateProxy: AdaptivePresentaionControllerDelegateProxy

  init(dependency: TopupInteractorDependency) {
    presentationDelegateProxy = AdaptivePresentaionControllerDelegateProxy()
    self.depedency = dependency
    super.init()
    presentationDelegateProxy.delegate = self
  }

  override func didBecomeActive() {
    super.didBecomeActive()

    if let card = self.depedency.cardOnFileRepository.cardOnFile.value.first { // 카드가 있으면
      self.depedency.paymentMethodStream.send(card)
      router?.attachEnterAmount()
    } else {
      router?.attachAddPaymentMethod()
    }
  }

  override func willResignActive() {
    super.willResignActive()

    router?.cleanupViews()
    // TODO: Pause any business logic.
  }

  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
    listener?.topupDidClose() 
  }

  func addPaymentMethodDidAddCard(method: PaymentMethod) {
     
  }

  func presentationControllerDidDismiss() {
    listener?.topupDidClose()
  }

  func enterAmountDidTapClose() {
    router?.detachEnterAmount()
    listener?.topupDidClose()
  }

  func enterAmountDidTapPayemtMethod() {
    router?.attachCardOnFile(paymentMethods: paymentMethods)
  }

  func enterAmountDidTapTopup(with amount: Double) {

  }

  func cardOnFileDidTapClose() {
    router?.detachCardOnFile()
  }

  func cardOnFileDidTapAddCard() {
    router?.attachAddPaymentMethod()
  }

  func cardOnFileDidSelect(at index: Int) {
    if let select = paymentMethods[safe: index] {
      self.depedency.paymentMethodStream.send(select)
    }
    router?.detachCardOnFile()
  }
}
