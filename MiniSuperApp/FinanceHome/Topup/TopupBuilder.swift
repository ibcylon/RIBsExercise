//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/26.
//

import ModernRIBs

protocol TopupDependency: Dependency {
  // TODO: Make sure to convert the variable into lower-camelcase.
  var topupBaseViewController: ViewControllable { get }
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency, CardOnFileDependency {
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { paymentMethodStream }
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  let paymentMethodStream: CurrentValuePublisher<PaymentMethod>

  // TODO: Make sure to convert the variable into lower-camelcase.
  fileprivate var TopupViewController: ViewControllable {
    return dependency.topupBaseViewController
  }
  init(
    dependency: TopupDependency,
    paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  ) {
    self.paymentMethodStream = paymentMethodStream
    super.init(dependency: dependency)
  }
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
  func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

  override init(dependency: TopupDependency) {
    super.init(dependency: dependency)
  }

  func build(withListener listener: TopupListener) -> TopupRouting {
    let paymentMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))
    let component = TopupComponent(dependency: dependency, paymentMethodStream: paymentMethodStream)
    let interactor = TopupInteractor(dependency: component)
    interactor.listener = listener

    let addPaymentBuilder = AddPaymentMethodBuilder(dependency: component)
    let enterAmountBuilder = EnterAmountBuilder(dependency: component)
    let cardOnFileBuilder = CardOnFileBuilder(dependency: component)
    return TopupRouter(interactor: interactor,
                       viewController: component.TopupViewController,
                       addPaymentMethodBuildable: addPaymentBuilder,
                       enterAmountBuildable: enterAmountBuilder,
                       cardOnFileBuildable: cardOnFileBuilder
    )
  }
}
