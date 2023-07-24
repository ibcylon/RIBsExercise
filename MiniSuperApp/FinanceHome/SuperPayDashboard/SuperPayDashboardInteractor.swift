//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import ModernRIBs
import Combine
import Foundation

protocol SuperPayDashboardRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashboardPresentable: Presentable {
  var listener: SuperPayDashboardPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.

  func updateBalance(_ balance: String)
}

protocol SuperPayDashboardListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

// 생성자가 수정될 경우, 참조된 다른 코드에서 수정이 많이 일어난다. 따라서
// dependency로 감싸면 수정할 일이 많이 줄어들기 때문에 사용한다
protocol SuperPayDashboardInteractorDependency {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
  var balanceFormatter: NumberFormatter { get }
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {

  weak var router: SuperPayDashboardRouting?
  weak var listener: SuperPayDashboardListener?

  private let dependency: SuperPayDashboardInteractorDependency

  private var cancellable: Set<AnyCancellable>

  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(presenter: SuperPayDashboardPresentable,
       dependency: SuperPayDashboardInteractorDependency
  ) {
    self.dependency = dependency
    self.cancellable = .init()
    super.init(presenter: presenter)
    presenter.listener = self
  }

  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.

    // RIBS에서 UI관련은 프레젠터를 호출하여 명령한다.
    // presenter가 self에 있으니까 [weak self] 선언
    dependency.balance.sink { [weak self] balance in
      self?.dependency.balanceFormatter.string(from: NSNumber(value: balance)).map {
        self?.presenter.updateBalance($0)
      }
    }.store(in: &cancellable)

    // subscribe는 cancellable에 저장함
  }

  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
}
