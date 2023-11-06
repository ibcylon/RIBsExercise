//
//  Combine+Utils.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import Foundation
import Combine
import CombineExt

// 잔액이나 금액과 같이 자주 변경되는 것들은 Stream으로 만들어 관리하는 것이 좋다.
// Data와 UI의 차이도 줄일 수 있다.
// Custom Publisher를 만든 이유 - currentValueSubject 로 볼 수 있음. 접근은 가능하지만 send는 불가능하게
public class ReadOnlyCurrentValuePublisher<Element>: Publisher {

  public typealias Output = Element
  public typealias Failure = Never

  public var value: Element {
    currentValueRelay.value
  }

  fileprivate let currentValueRelay: CurrentValueRelay<Output>

  fileprivate init(_ initialValue: Element) {
    currentValueRelay = CurrentValueRelay(initialValue)
  }

  public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Element == S.Input {
    currentValueRelay.receive(subscriber: subscriber)
  }
}

public final class CurrentValuePublisher<Element>: ReadOnlyCurrentValuePublisher<Element> {
  typealias Output = Element
  typealias Failure = Never

  public override init(_ initialValue: Element) {
    super.init(initialValue)
  }

  public func send(_ value: Element) {
    currentValueRelay.accept(value)
  }
}
