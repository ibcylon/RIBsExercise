//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import ModernRIBs
import Combine

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }

  func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol CardOnFileDashboardInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    weak var router: CardOnFileDashboardRouting?
    weak var listener: CardOnFileDashboardListener?

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
}
