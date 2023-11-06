//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import ModernRIBs
import Combine
import FinanceRepository

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }

  func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject { // 부모에게 이벤트 발생을 알릴 수 있다.

    func cardOnFileDashboardDidTapAddPaymentMethod()
}

protocol CardOnFileDashboardInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    weak var router: CardOnFileDashboardRouting?
    weak var listener: CardOnFileDashboardListener? // 리스너는 부모 리블렛의 interactor이다.

  private let dependency: CardOnFileDashboardInteractorDependency

  private var cancellable: Set<AnyCancellable>
    // in constructor.
    init(presenter: CardOnFileDashboardPresentable,
         dependency: CardOnFileDashboardInteractorDependency
    ) {
      self.dependency = dependency
      self.cancellable = .init()
      super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

      // weak self는 retain cycle을 없애기 위해서 사용하는 건데
      // 화면이 가려질 때(없애질 때만이아님 모두 해제시켜주면 된다.

      dependency.cardOnFileRepository.cardOnFile.sink { methods in
        self.presenter.update(with: methods.prefix(5).map { PaymentMethodViewModel.init($0) })
      }.store(in: &cancellable)
    }

    override func willResignActive() {
        super.willResignActive()

      cancellable.forEach { $0.cancel() }
      cancellable.removeAll()

      // 화면이 가려질 때 cancellable 하니까 retain되지 않음
    }

  // 여기서 라우팅 로직을 호출할 수도 있으나 CardOnFile은 전체 화면이 아니라 일부분이다.
  // 따라서, 전체 화면인 finance 모듈화면에서 라우팅 호출을 하는 거싱 적절하다.
  func addPaymentMethodDidTap() {
    // 리블렛 끼리의 통신은 두뇌 역할인 interactor 끼리하게 된다.
    // 부모에서 자식으로의 통신은 Stream pub: sub 1:N 으로 이루어지며
    // 자식에서 부모는 항상 부모가 하나이기 때문에 1:1으로 delegate로 이루어지게 된다.
    listener?.cardOnFileDashboardDidTapAddPaymentMethod()

    // 이제 부모 리블렛에서 해당 메소드를 구현해줌
  }

}
