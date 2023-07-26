//
//  AddPaymentMethodBuilder.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import ModernRIBs

protocol AddPaymentMethodDependency: Dependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodComponent: Component<AddPaymentMethodDependency>, AddPaymentMethodInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
}

// MARK: - Builder

protocol AddPaymentMethodBuildable: Buildable {
  func build(withListener listener: AddPaymentMethodListener) -> AddPaymentMethodRouting
}

final class AddPaymentMethodBuilder: Builder<AddPaymentMethodDependency>, AddPaymentMethodBuildable {

  override init(dependency: AddPaymentMethodDependency) {
    super.init(dependency: dependency)
  }

  func build(withListener listener: AddPaymentMethodListener) -> AddPaymentMethodRouting {
    let component = AddPaymentMethodComponent(dependency: dependency)
    let viewController = AddPaymentMethodViewController()
    let interactor = AddPaymentMethodInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener
    return AddPaymentMethodRouter(interactor: interactor, viewController: viewController)
  }
}
