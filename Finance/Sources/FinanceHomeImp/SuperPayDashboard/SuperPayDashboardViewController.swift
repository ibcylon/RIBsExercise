//
//  SuperPayDashboardViewController.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import ModernRIBs
import UIKit

protocol SuperPayDashboardPresentableListener: AnyObject {
  func topupButtonDidTap()
}

final class SuperPayDashboardViewController: UIViewController, SuperPayDashboardPresentable, SuperPayDashboardViewControllable {

  weak var listener: SuperPayDashboardPresentableListener?

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
    label.text = "수퍼페이 잔고"
    return label
  }()

  private lazy var button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("충전하기", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.addTarget(self, action: #selector(topupButtonDidTap), for: .touchUpInside)
    return button
  }()

  private let cardView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 16
    view.layer.cornerCurve = .continuous
    view.backgroundColor = .systemIndigo
    return view
  }()

  private let currencyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22, weight: .semibold)
    label.textColor = .white
    label.text = "원"
    return label
  }()

  private let balanceAmoutLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22, weight: .semibold)
    label.textColor = .white
    return label
  }()

  private let balanceStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.axis = .horizontal
    stackView.spacing = 4
    return stackView
  }()

  init() {
    super.init(nibName: nil, bundle: nil)

    setupViews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    setupViews()
  }

  func setupViews() {
    view.addSubview(headerStackView)
    view.addSubview(cardView)

    headerStackView.addArrangedSubview(label)
    headerStackView.addArrangedSubview(button)

    cardView.addSubview(balanceStackView)
    balanceStackView.addArrangedSubview(balanceAmoutLabel)
    balanceStackView.addArrangedSubview(currencyLabel)
    
    NSLayoutConstraint.activate([
      headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
      headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

      cardView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
      cardView.heightAnchor.constraint(equalToConstant: 100),
      cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),

      balanceStackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
      balanceStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
    ])
  }

  @objc
  func topupButtonDidTap(_ sender: UIButton) {
    listener?.topupButtonDidTap()
  }

  func updateBalance(_ balance: String) {
    balanceAmoutLabel.text = balance
  }



}
