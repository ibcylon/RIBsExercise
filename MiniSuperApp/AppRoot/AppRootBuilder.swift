import ModernRIBs
import UIKit
import FinanceRepository
import FinanceHomeImp
import AppHome
import ProfileHome

protocol AppRootDependency: Dependency {
}


// MARK: - Builder

protocol AppRootBuildable: Buildable {
  func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler)
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {
  
  override init(dependency: AppRootDependency) {
    super.init(dependency: dependency)
  }
  
  func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler) {

    let cardOnFileRepository = CardOnFileRepositoryImp()
    let superPayRepository = SuperPayRepositoryImp()
    let tabBar = RootTabBarController()

    let component = AppRootComponent(
      dependnecy: dependency,
      cardOnFileRepository: cardOnFileRepository,
      superPayRepository: superPayRepository,
      rootViewControllable: tabBar
    )
    
    let interactor = AppRootInteractor(presenter: tabBar)

    let appHome = AppHomeBuilder(dependency: component)
    let financeHome = FinanceHomeBuilder(dependency: component)
    let profileHome = ProfileHomeBuilder(dependency: component)
    let router = AppRootRouter(
      interactor: interactor,
      viewController: tabBar,
      appHome: appHome,
      financeHome: financeHome,
      profileHome: profileHome
    )
    
    return (router, interactor)
  }
}
