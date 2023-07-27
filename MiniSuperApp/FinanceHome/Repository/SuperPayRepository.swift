//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/27.
//

import Foundation
import Combine

protocol SuperPayRepository {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }

  func topup(amount: Double, payMethodID: String) -> AnyPublisher<Void, Error>
}

final class SuperPayRepositoryImp: SuperPayRepository {
  var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }

  private let balanceSubject = CurrentValuePublisher<Double>(0)

  func topup(amount: Double, payMethodID: String) -> AnyPublisher<Void, Error> {
    return Future<Void, Error> { [weak self] promise in
      self?.backgroundQueue.async {
        Thread.sleep(forTimeInterval: 2)
        promise(.success(()))
        let newBalance = (self?.balanceSubject.value).map { $0 + amount }
        newBalance.map { self?.balanceSubject.send($0) }

      }
    }.eraseToAnyPublisher()
  }

  private let backgroundQueue = DispatchQueue(label: "topup.repository.queueu")
}
