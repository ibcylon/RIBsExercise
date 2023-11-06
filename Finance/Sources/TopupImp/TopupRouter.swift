//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/26.
//

import ModernRIBs

import AddPaymentMethod
import SuperUI
import FinanceEntity
import RIBsUtil
import Topup

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener  {
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

  private let cardOnFileBuildable: CardOnFileBuildable
  private var cardOnFileRouting: Routing?

  private var navigationControllable: NavigationControllerable?

  // TODO: Constructor inject child builder protocols to allow building children.
  init(interactor: TopupInteractable,
       viewController: ViewControllable,
       addPaymentMethodBuildable: AddPaymentMethodBuildable,
       enterAmountBuildable: EnterAmountBuildable,
       cardOnFileBuildable: CardOnFileBuildable
  ) {
    self.viewController = viewController
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    self.enterAmountBuildable = enterAmountBuildable
    self.cardOnFileBuildable = cardOnFileBuildable
    super.init(interactor: interactor)
    interactor.router = self
  }

  func cleanupViews() { // ResignActive 시점에 호출돼서 다 닫음
    if viewController.uiviewController.presentationController != nil, navigationControllable != nil {
      navigationControllable?.dismiss(completion: nil)
    }
  }

  func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
    if addPaymentMethodRouting != nil { return }

    let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: closeButtonType)

    if let navigation = navigationControllable {
      navigation.pushViewController(router.viewControllable, animated: true)
    } else {
      presentInsideNavigation(router.viewControllable)
    }

    attachChild(router)

    addPaymentMethodRouting = router
  }

  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else { return }

    navigationControllable?.popViewController(animated: true)
//    dismissPresentNavigation(completion: nil)
    detachChild(router)
    addPaymentMethodRouting = nil
  }

  func attachEnterAmount() {
    if enterAmountRouting != nil { return }
    let router = enterAmountBuildable.build(withListener: interactor)

    if let navigation = navigationControllable { // 분기 처리 - 카드가 없어서 카드 추가 후 창이 띄워진 것
      navigation.setViewControllers([router.viewControllable])
      resetChildRouting()
    } else {
      presentInsideNavigation(router.viewControllable)
    }

    attachChild(router)

    enterAmountRouting = router
  }

  func detachEnterAmount() {
    guard let router = enterAmountRouting else { return }
    dismissPresentNavigation(completion: nil)
    detachChild(router)
    enterAmountRouting = nil
  }

  func attachCardOnFile(paymentMethods: [PaymentMethod]) {
    if cardOnFileRouting != nil { return }
    let router = cardOnFileBuildable.build(withListener: interactor, paymentMethods: paymentMethods)
    navigationControllable?.pushViewController(router.viewControllable, animated: true)
    cardOnFileRouting = router
    attachChild(router)
  }

  func detachCardOnFile() {
    guard let router = cardOnFileRouting else { return }
    navigationControllable?.popViewController(animated: true)
    detachChild(router)
    cardOnFileRouting = nil
  }

  func poptoRoot() {
    navigationControllable?.popToRoot(animated: true)
    resetChildRouting()
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

  private func resetChildRouting() {
    if let router = cardOnFileRouting {
      detachChild(router)
      cardOnFileRouting = nil
    }

//    if let router = enterAmountRouting {
//      detachChild(router)
//      enterAmountRouting = nil
//    }

    if let router = addPaymentMethodRouting {
      detachChild(router)
      addPaymentMethodRouting = nil
    }
  }



  private let viewController: ViewControllable
}
