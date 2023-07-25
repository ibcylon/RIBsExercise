//
//  AddPaymentMethodViewController.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import ModernRIBs
import UIKit

protocol AddPaymentMethodPresentableListener: AnyObject {
    func didTapClose()
}

final class AddPaymentMethodViewController: UIViewController, AddPaymentMethodPresentable, AddPaymentMethodViewControllable {

  weak var listener: AddPaymentMethodPresentableListener?

  init() {
    super.init(nibName: nil, bundle: nil)

    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let cardNumberTextField: UITextField = {
    let textField = makeTextField()
    textField.placeholder = "카드 번호"
    return textField
  }()

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.spacing = 14
    return stackView
  }()

  private let securityTextField: UITextField = {
    let textField = makeTextField()
    textField.placeholder = "CVC"
    return textField
  }()

  private let expirationTextField: UITextField = {
    let textField = makeTextField()
    textField.placeholder = "유효 기간"
    return textField
  }()

  private lazy var addCardButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.roundCorners()
    button.backgroundColor = .primaryRed
    button.setTitleColor(.white, for: .normal)
    button.setTitle("추가하기", for: .normal)
    button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    return button
  }()

  private static func makeTextField() -> UITextField {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    textField.backgroundColor = .white
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }

  private func setupViews() {
    title = "카드 추가"

    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold))
      ,
      style: .plain,
      target: self,
      action: #selector(didTapClose)
    )

    view.backgroundColor = .backgroundColor
    view.addSubview(cardNumberTextField)
    view.addSubview(stackView)
    view.addSubview(addCardButton)

    stackView.addArrangedSubview(securityTextField)
    stackView.addArrangedSubview(expirationTextField)

    NSLayoutConstraint.activate([
      cardNumberTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
      cardNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      cardNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

      cardNumberTextField.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

      stackView.bottomAnchor.constraint(equalTo: addCardButton.topAnchor, constant: -20),
      addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

      cardNumberTextField.heightAnchor.constraint(equalToConstant: 60),
      securityTextField.heightAnchor.constraint(equalToConstant: 60),
      expirationTextField.heightAnchor.constraint(equalToConstant: 60),
      addCardButton.heightAnchor.constraint(equalToConstant: 60),
    ])
  }

  @objc
  func addButtonDidTap() {

  }

  // 부모가 책임지고 자식의 뷰컨트롤러의 생명주기를 관리할 수 있게 되어 좋다.
  // 유저가 dismiss하는 것도 캐치해서 잡아야 한다.
  @objc
  func didTapClose() {
    listener?.didTapClose()
  }
}
