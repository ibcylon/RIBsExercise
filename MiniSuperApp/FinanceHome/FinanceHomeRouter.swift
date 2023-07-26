import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener, TopupListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
  var presentationDelegateProxy: AdaptivePresentaionControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
  func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {

  let superPayDashboardBuildable: SuperPayDashboardBuildable
  private var superPayRouting: Routing?

  let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
  private var cardOnFileRouting: Routing?

  let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?

  let topupBuildable: TopupBuildable
  private var topupRouting: Routing?

  init(interactor: FinanceHomeInteractable,
       viewController: FinanceHomeViewControllable,
       superPayDashboardBuildable: SuperPayDashboardBuildable,
       cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
       addPaymentMethodBuildable: AddPaymentMethodBuildable,
       topupBuildable: TopupBuildable
  ) {
    self.superPayDashboardBuildable = superPayDashboardBuildable
    self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    self.topupBuildable = topupBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }

  func attachSuperPayDashboard() {
    if superPayRouting != nil { return } // 같은 뷰 중복 피하기 위한 방어 로직
    let router = superPayDashboardBuildable.build(withListener: interactor)

    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)

    self.superPayRouting = router

    attachChild(router)
  }

  func attachCardOnFileDashboard() {
    if cardOnFileRouting != nil { return }
    let router = cardOnFileDashboardBuildable.build(withListener: interactor)

    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard )

    self.cardOnFileRouting = router
    attachChild(router)
  }

  func attachAddPaymentMethod() {
    if addPaymentMethodRouting != nil { return }
    let router = addPaymentMethodBuildable.build(withListener: interactor)

    // viewController, viewControllable 모두 UI객체가 아니기 때문에 present method가 없다.
    // 립스 전역에서 쓰이는 메소드이기 때문에 RIBS.Utills에 추가되어 있음.
    let navigation = NavigationControllerable(root: router.viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    viewControllable.present(navigation, animated: true, completion: nil)

    self.addPaymentMethodRouting = router
    attachChild(router)
  }

  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else {
      return
    }
    viewControllable.dismiss(completion: nil)

    detachChild(router)

    addPaymentMethodRouting = nil
  }

  func attachTopup() {
    if topupRouting != nil { return }
    let router = topupBuildable.build(withListener: interactor)

    // viewControllable이 없기 때문에 붙일 필요 없음
    self.topupRouting = router
    attachChild(router)
  }

  func detachTopup() {
    guard let router = topupRouting else { return }
    detachChild(router)

    topupRouting = nil
  }
}
