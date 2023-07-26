//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import Foundation
import Combine

protocol CardOnFileRepository {
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }

  func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
}

final class CardOnFileRepositoryImp: CardOnFileRepository {
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { cardOnFileSubject }

  private let cardOnFileSubject = CurrentValuePublisher<[PaymentMethod]>([
      PaymentMethod(id: "0", name: "우리은행", digits: "8888", color: "#f19138ff", isPrimary: false),
      PaymentMethod(id: "1", name: "신한은행", digits: "8888", color: "#3478f6ff", isPrimary: false),
      PaymentMethod(id: "2", name: "국민은행", digits: "8888", color: "#78c5f5ff", isPrimary: false),
//      PaymentMethod(id: "3", name: "토스은행", digits: "8888", color: "#f19138ff", isPrimary: false),
//      PaymentMethod(id: "4", name: "카카오은행", digits: "8888", color: "#f19138ff", isPrimary: false),
    ])

  func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
    let paymentMethod = PaymentMethod(id: "0", name: "new 카드", digits: "\(info.number.suffix(4))", color: "", isPrimary: false)

    var new = cardOnFileSubject.value 
    new.append(paymentMethod)
    cardOnFileSubject.send(new)
    
    return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
}
