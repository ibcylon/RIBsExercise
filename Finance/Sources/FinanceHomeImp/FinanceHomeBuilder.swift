import ModernRIBs
import FinanceRepository
import AddPaymentMethod
import CombineUtil
import Topup
import FinanceHome

public protocol FinanceHomeDependency: Dependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }
  var topupBuildable: TopupBuildable { get }
}

// 자식들의 Riblet을 conform하도록 해줘야 함. component는 바구니의 역할

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency {

  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }

  var topupBuildable: TopupBuildable { dependency.topupBuildable }
}

// MARK: - Builder


public final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
  public override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: FinanceHomeListener) -> ViewableRouting {
    let viewController = FinanceHomeViewController()
    let component = FinanceHomeComponent(
      dependency: dependency
    )
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener

    let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
    let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
    let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)

    return FinanceHomeRouter(
      interactor: interactor,
      viewController: viewController,
      superPayDashboardBuildable: superPayDashboardBuilder,
      cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
      addPaymentMethodBuildable: addPaymentMethodBuilder,
      topupBuildable: component.topupBuildable
    )
  }
}
