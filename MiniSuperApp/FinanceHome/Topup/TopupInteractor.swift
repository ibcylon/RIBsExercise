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
}

protocol TopupListener: AnyObject {
  func topupDidClose()
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentaionControllerDelegate {

  weak var router: TopupRouting?
  weak var listener: TopupListener?
  private let depedency: TopupInteractorDependency


  let presentationDelegateProxy: AdaptivePresentaionControllerDelegateProxy

  init(dependency: TopupInteractorDependency) {
    presentationDelegateProxy = AdaptivePresentaionControllerDelegateProxy()
    self.depedency = dependency
    super.init()
    presentationDelegateProxy.delegate = self
  }

  override func didBecomeActive() {
    super.didBecomeActive()

    print("topup attached")
    if self.depedency.cardOnFileRepository.cardOnFile.value.isEmpty { // 카드가 없다면 카드 추가 분기
      router?.attachAddPaymentMethod()
    } else {
      router?.attachEnterAmount()
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
}
