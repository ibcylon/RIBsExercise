import ModernRIBs

protocol FinanceHomeRouting: ViewableRouting {
  func attachSuperPayDashboard()
  func attachCardOnFileDashboard()
  func attachAddPaymentMethod()
  func detachAddPaymentMethod()
  func attachTopup()
  func detachTopup()
}

protocol FinanceHomePresentable: Presentable {
  var listener: FinanceHomePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FinanceHomeListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable>, FinanceHomeInteractable, FinanceHomePresentableListener, AdaptivePresentaionControllerDelegate {

  weak var router: FinanceHomeRouting?
  weak var listener: FinanceHomeListener?

  let presentationDelegateProxy: AdaptivePresentaionControllerDelegateProxy
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: FinanceHomePresentable) {
    presentationDelegateProxy = AdaptivePresentaionControllerDelegateProxy()
    super.init(presenter: presenter)
    presenter.listener = self
    presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.

    router?.attachSuperPayDashboard()
    router?.attachCardOnFileDashboard()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }

  func presentationControllerDidDismiss() {
    router?.detachAddPaymentMethod()
  }
  // MARK: CardOnFileDashboard Listenr
  func cardOnFileDashboardDidTapAddPaymentMethod() {
    router?.attachAddPaymentMethod()
  }

  // MARK: AddPaymentMethod Listener
  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
  }

  func addPaymentMethodDidAddCard(method: PaymentMethod) {
    router?.detachAddPaymentMethod()
  }

  // MARK: SuperPayDashboard Listener
  func superPayDashboardDidTapTopup() {
    router?.attachTopup()
  }

  // MARK: Topup Listenr
  func topupDidClose() {
    router?.detachTopup()
  }
}
