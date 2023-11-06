//
//  AddPaymentMethodInteractor.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import ModernRIBs
import Combine
import FinanceEntity
import FinanceRepository

protocol AddPaymentMethodRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AddPaymentMethodPresentable: Presentable {
  var listener: AddPaymentMethodPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol AddPaymentMethodListener: AnyObject { // 부모 리플렛에게 전달
  func addPaymentMethodDidTapClose()
  func addPaymentMethodDidAddCard(method: PaymentMethod)
}

protocol AddPaymentMethodInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodInteractor: PresentableInteractor<AddPaymentMethodPresentable>, AddPaymentMethodInteractable, AddPaymentMethodPresentableListener {

  weak var router: AddPaymentMethodRouting?
  weak var listener: AddPaymentMethodListener?

  private let dependency: AddPaymentMethodInteractorDependency
  private var cancellables: Set<AnyCancellable>
  // in constructor.
  init(presenter: AddPaymentMethodPresentable,
       dependency: AddPaymentMethodInteractorDependency
  ) {
    self.dependency = dependency
    self.cancellables = .init()
    super.init(presenter: presenter)
    presenter.listener = self
  }

  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
  }

  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }

  func didTapClose() {
    listener?.addPaymentMethodDidTapClose()
  }

  func didTapAddCard(number: String, cvc: String, expiry: String) {
    let info = AddPaymentMethodInfo(number: number, cvc: cvc, expiry: expiry)
    dependency.cardOnFileRepository.addCard(info: info).sink { _ in

    } receiveValue: { [weak self] method in
      self?.listener?.addPaymentMethodDidAddCard(method: method)
    }.store(in: &cancellables )

  }
}
