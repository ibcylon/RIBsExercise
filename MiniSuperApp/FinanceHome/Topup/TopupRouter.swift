//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/26.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener  {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
  var presentationDelegateProxy: AdaptivePresentaionControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?

  private let enterAmountBuildable: EnterAmountBuildable
  private var enterAmountRouting: Routing?

  private var navigationControllable: NavigationControllerable?

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: TopupInteractable,
         viewController: ViewControllable,
         addPaymentMethodBuildable: AddPaymentMethodBuildable,
         enterAmountBuildable: EnterAmountBuildable
    ) {
        self.viewController = viewController
      self.addPaymentMethodBuildable = addPaymentMethodBuildable
      self.enterAmountBuildable = enterAmountBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() { // ResignActive 시점에 호출돼서 다 닫음
      if viewController.uiviewController.presentationController != nil, navigationControllable != nil {
        navigationControllable?.dismiss(completion: nil)
      }
    }

  func attachAddPaymentMethod() {
    if addPaymentMethodRouting != nil { return }
    let router = addPaymentMethodBuildable.build(withListener: interactor)
    presentInsideNavigation(router.viewControllable)
    attachChild(router)

    addPaymentMethodRouting = router
  }

  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else { return }
    dismissPresentNavigation(completion: nil)
    detachChild(router)
    addPaymentMethodRouting = nil
  }

  func attachEnterAmount() {
    if enterAmountRouting != nil { return }
    let router = enterAmountBuildable.build(withListener: interactor)
    presentInsideNavigation(router.viewControllable)
    attachChild(router)

    enterAmountRouting = router
  }

  func detachEnterAmount() {
    guard let router = enterAmountRouting else { return }
    dismissPresentNavigation(completion: nil)
    detachChild(router)
    enterAmountRouting = nil
  }

  // MARK: - Private

  private func presentInsideNavigation(_ viewControllable: ViewControllable) {
    let navigation = NavigationControllerable(root: viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    self.navigationControllable = navigation
    viewController.present(navigation, animated: true, completion: nil)
  }

  private func dismissPresentNavigation(completion: (() -> Void)?) {
    if self.navigationControllable == nil {
      return
    }

    viewController.dismiss(completion: nil)
    self.navigationControllable = nil
  }



    private let viewController: ViewControllable
}
