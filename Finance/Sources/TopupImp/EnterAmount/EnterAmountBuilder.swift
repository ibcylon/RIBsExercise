//
//  EnterAmountBuilder.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/26.
//

import ModernRIBs
import CombineUtil
import FinanceEntity
import FinanceRepository

protocol EnterAmountDependency: Dependency {
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
  var superPayRepository: SuperPayRepository { get }
}

final class EnterAmountComponent: Component<EnterAmountDependency>, EnterAmountInteractorDependency {
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { dependency.selectedPaymentMethod }
}

// MARK: - Builder

protocol EnterAmountBuildable: Buildable {
    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting
}

final class EnterAmountBuilder: Builder<EnterAmountDependency>, EnterAmountBuildable {

    override init(dependency: EnterAmountDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting {
        let component = EnterAmountComponent(dependency: dependency)
        let viewController = EnterAmountViewController()
        let interactor = EnterAmountInteractor(
          presenter: viewController,
          dependency: component
        )
        interactor.listener = listener
        return EnterAmountRouter(interactor: interactor, viewController: viewController)
    }
}
