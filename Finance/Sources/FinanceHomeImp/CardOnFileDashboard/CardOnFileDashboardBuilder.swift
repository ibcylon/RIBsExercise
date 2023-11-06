//
//  CardOnFileDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import ModernRIBs
import FinanceRepository

protocol CardOnFileDashboardDependency: Dependency, CardOnFileDashboardInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardComponent: Component<CardOnFileDashboardDependency>, CardOnFileDashboardInteractorDependency {

    // 카드 레포지토리 또한 파이넌스 모듈 최상위에서 주입 받는게 적절하기 때문에 부모에게 요청함
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
}

// MARK: - Builder

protocol CardOnFileDashboardBuildable: Buildable {
    func build(withListener listener: CardOnFileDashboardListener) -> CardOnFileDashboardRouting
}

final class CardOnFileDashboardBuilder: Builder<CardOnFileDashboardDependency>, CardOnFileDashboardBuildable {

    override init(dependency: CardOnFileDashboardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CardOnFileDashboardListener) -> CardOnFileDashboardRouting {
        let component = CardOnFileDashboardComponent(dependency: dependency)
        let viewController = CardOnFileDashboardViewController()
        let interactor = CardOnFileDashboardInteractor(
          presenter: viewController,
          dependency: component
        )
        interactor.listener = listener
        return CardOnFileDashboardRouter(interactor: interactor, viewController: viewController)
    }
}
