//
//  PaymentMethodView.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import UIKit

final class PaymentMethodView: UIView {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .white
    label.font = .systemFont(ofSize: 18, weight: .semibold)
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .white
    label.font = .systemFont(ofSize: 15, weight: .semibold)
    return label
  }()

  init(_ viewModel: PaymentMethodViewModel) {
    super.init(frame: .zero)

    setupViews()

    titleLabel.text = viewModel.name
    subtitleLabel.text = viewModel.digits
    backgroundColor = viewModel.color
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    setupViews()
  }

  private func setupViews() {
    addSubview(titleLabel)
    addSubview(subtitleLabel)

    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      subtitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
}
