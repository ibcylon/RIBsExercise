//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import Foundation
import Combine
import FinanceEntity
import CombineUtil

public protocol CardOnFileRepository {
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }

  func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
}

public final class CardOnFileRepositoryImp: CardOnFileRepository {
  public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { cardOnFileSubject }

  private let cardOnFileSubject = CurrentValuePublisher<[PaymentMethod]>([
      PaymentMethod(id: "0", name: "우리은행", digits: "8888", color: "#f19138ff", isPrimary: false),
      PaymentMethod(id: "3", name: "토스은행", digits: "8888", color: "#f19138ff", isPrimary: false),
      PaymentMethod(id: "4", name: "카카오은행", digits: "8888", color: "#f19138ff", isPrimary: false),
    ])

  public init() { }

  public func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
    let paymentMethod = PaymentMethod(id: "0", name: "new 카드", digits: "\(info.number.suffix(4))", color: "", isPrimary: false)

    var new = cardOnFileSubject.value 
    new.append(paymentMethod)
    cardOnFileSubject.send(new)
    
    return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
}
