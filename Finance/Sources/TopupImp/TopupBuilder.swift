//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/26.
//

import ModernRIBs
import FinanceRepository
import AddPaymentMethod
import CombineUtil
import FinanceEntity
import Topup

public protocol TopupDependency: Dependency {
  // TODO: Make sure to convert the variable into lower-camelcase.
  var topupBaseViewController: ViewControllable { get }
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency, CardOnFileDependency {
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
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


public final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

  public override init(dependency: TopupDependency) {
    super.init(dependency: dependency)
  }

  public func build(withListener listener: TopupListener) -> Routing {
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
