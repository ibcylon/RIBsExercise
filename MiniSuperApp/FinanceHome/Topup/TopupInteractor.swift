//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/26.
//

import ModernRIBs

protocol TopupRouting: Routing {
  func cleanupViews()
  func attachAddPaymentMethod(closeButtonType: DismissButtonType)
  func detachAddPaymentMethod()
  func attachEnterAmount()
  func detachEnterAmount()
  func attachCardOnFile(paymentMethods: [PaymentMethod])
  func detachCardOnFile()
  func poptoRoot()
}

protocol TopupListener: AnyObject {
  func topupDidClose()
  func topupDidFinish()
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentaionControllerDelegate {

  weak var router: TopupRouting?
  weak var listener: TopupListener?
  private let depedency: TopupInteractorDependency

  private var isEnterAmountRoot: Bool = false // 이 플래그가 필요한 이유는 카드가 존재했을 때 / 없을 떄 구분해서 이미 enteramount가 있으면 다시 붙이는 게 안되기 때문

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
      isEnterAmountRoot = true
      self.depedency.paymentMethodStream.send(card)
      router?.attachEnterAmount()
    } else {
      isEnterAmountRoot = false
      router?.attachAddPaymentMethod(closeButtonType: .close)
    }
  }

  override func willResignActive() {
    super.willResignActive()

    router?.cleanupViews()
    // TODO: Pause any business logic.
  }

  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
    if isEnterAmountRoot == false {
      listener?.topupDidClose()
    }
  }

  func addPaymentMethodDidAddCard(method: PaymentMethod) {
    depedency.paymentMethodStream.send(method)

    if isEnterAmountRoot {
      router?.poptoRoot()
    } else {
      isEnterAmountRoot = true
      router?.attachEnterAmount()
    }
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

  func enterAmountDidFinishTopup() {
    listener?.topupDidFinish()
  }

  // MARK: CardOnFile

  func cardOnFileDidTapClose() {
    router?.detachCardOnFile()
  }

  func cardOnFileDidTapAddCard() {
    router?.attachAddPaymentMethod(closeButtonType: .back )
  }

  func cardOnFileDidSelect(at index: Int) {
    if let select = paymentMethods[safe: index] {
      self.depedency.paymentMethodStream.send(select)
    }
    router?.detachCardOnFile()
  }
}
