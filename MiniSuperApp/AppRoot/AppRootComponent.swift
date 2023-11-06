//
//  AppHomeComponent.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/11/06.
//

import Foundation
import ModernRIBs
import AppHome
import FinanceHome
import FinanceHomeImp
import ProfileHome
import TransportHome
import TransportHomeImp
import FinanceRepository
import TopupImp
import Topup

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency, TopupDependency {
  let cardOnFileRepository: CardOnFileRepository
  let superPayRepository: SuperPayRepository

  lazy var transportHomeBuildable: TransportHomeBuildable = {
    TransportHomeBuilder(dependency: self)
  }()

  lazy var topupBuildable: TopupBuildable = {
    TopupBuilder(dependency: self)
  }()

  var topupBaseViewController: ModernRIBs.ViewControllable { return rootViewControllable.topViewControllable }
  private let rootViewControllable: ViewControllable

  init(dependnecy: AppRootDependency,
       cardOnFileRepository: CardOnFileRepository,
       superPayRepository: SuperPayRepository,
       rootViewControllable: ViewControllable
  ) {
    self.cardOnFileRepository = cardOnFileRepository
    self.superPayRepository = superPayRepository
    self.rootViewControllable = rootViewControllable
    super.init(dependency: dependnecy)
  }
}
