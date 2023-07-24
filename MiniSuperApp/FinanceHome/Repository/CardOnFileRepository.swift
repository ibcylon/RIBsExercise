//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import Foundation

protocol CardOnFileRepository {
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
}

final class CardOnFileRepositoryImp: CardOnFileRepository {
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { cardOnFileSubject }

  private let cardOnFileSubject = CurrentValuePublisher<[PaymentMethod]>([
      PaymentMethod(id: "0", name: "우리은행", digits: "8888", color: "#f19138ff", isPrimary: false),
      PaymentMethod(id: "1", name: "신한은행", digits: "8888", color: "#3478f6ff", isPrimary: false),
      PaymentMethod(id: "2", name: "국민은행", digits: "8888", color: "#78c5f5ff", isPrimary: false),
      PaymentMethod(id: "3", name: "토스은행", digits: "8888", color: "#f19138ff", isPrimary: false),
      PaymentMethod(id: "4", name: "카카오은행", digits: "8888", color: "#f19138ff", isPrimary: false),
    ])
}
