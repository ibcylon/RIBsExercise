//
//  CardOnFileDashboardViewController.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import ModernRIBs
import UIKit

protocol CardOnFileDashboardPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class CardOnFileDashboardViewController: UIViewController, CardOnFileDashboardPresentable, CardOnFileDashboardViewControllable {

  weak var listener: CardOnFileDashboardPresentableListener?

  private let headerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .equalSpacing
    stackView.alignment = .fill
    return stackView
  }()

  private let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22, weight: .semibold)
    label.text = "카드 및 계좌"
    return label
  }()

  private lazy var seeAllButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("전체보기", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.addTarget(self, action: #selector(seeAllButtonDidTap), for: .touchUpInside)
    return button
  }()

  private let cardOnFileStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.alignment = .fill
    stackView.spacing = 12
    return stackView
  }()

  private lazy var addPaymentMethodButton: AddPaymentMethodButton = {
    let button = AddPaymentMethodButton()
    button.roundCorners()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(addPaymentMethodButtonDidTap), for: .touchUpInside)
    button.backgroundColor = .systemGray4
    return button
  }()


  init() {
    super.init(nibName: nil, bundle: nil)

    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {
    view.addSubview(headerStackView)
    view.addSubview(cardOnFileStackView)

    headerStackView.addArrangedSubview(label)
    headerStackView.addArrangedSubview(seeAllButton)

    NSLayoutConstraint.activate([
      headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
      headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -20),

      cardOnFileStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
      cardOnFileStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      cardOnFileStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -20),
      cardOnFileStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),

      addPaymentMethodButton.heightAnchor.constraint(equalToConstant: 60),

    ])
  }

  @objc
  func seeAllButtonDidTap(_ sender: UIButton) {

  }

  @objc
  func addPaymentMethodButtonDidTap() {

  }

  func update(with viewModels: [PaymentMethodViewModel]) {
    cardOnFileStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

    let views = viewModels.map(PaymentMethodView.init)

    views.forEach {
      $0.roundCorners()
      cardOnFileStackView.addArrangedSubview($0)
    }

    cardOnFileStackView.addArrangedSubview(addPaymentMethodButton)

    let heightConstraints = views.map { $0.heightAnchor.constraint(equalToConstant: 60) }

    NSLayoutConstraint.activate(heightConstraints)
    
  }
}
