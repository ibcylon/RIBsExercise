//
//  SuperPayDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import ModernRIBs
import Foundation
import CombineUtil

// 부모로 부터 받으려면 해당 리블렛에 선언
protocol SuperPayDashboardDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
}

// component는 바구니이다. 따라서 필요한 것들을 계속 추가해나갈 수 있다. 확장성이 있다.
// 해당 RIBLET은 UI구현이 주이기 때문에 여기에서 로직을 구하기 보다는 부모로 부터 받는게 바람직함
final class SuperPayDashboardComponent: Component<SuperPayDashboardDependency>, SuperPayDashboardInteractorDependency {
  var balanceFormatter: NumberFormatter { Formatter.balanceFormatter }
  var balance: ReadOnlyCurrentValuePublisher<Double> { dependency.balance }
}

// MARK: - Builder

protocol SuperPayDashboardBuildable: Buildable {
    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting
}

final class SuperPayDashboardBuilder: Builder<SuperPayDashboardDependency>, SuperPayDashboardBuildable {

    override init(dependency: SuperPayDashboardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting {
        let component = SuperPayDashboardComponent(dependency: dependency)
        let viewController = SuperPayDashboardViewController()
        let interactor = SuperPayDashboardInteractor(
          presenter: viewController,
          dependency: component
        )
        interactor.listener = listener
        return SuperPayDashboardRouter(interactor: interactor, viewController: viewController)
    }
}
