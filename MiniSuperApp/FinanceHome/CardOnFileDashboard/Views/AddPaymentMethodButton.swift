//
//  AddPaymentMethodButton.swift
//  MiniSuperApp
//
//  Created by Kanghos on 2023/07/24.
//

import UIKit

final class AddPaymentMethodButton: UIControl {
  private let plusIcon: UIImageView = {
    let imageView = UIImageView(
      image: UIImage(
        systemName: "plus",
        withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold))
    )
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.tintColor = .white
    return imageView
  }()

  init() {
    super.init(frame: .zero)

    setupViews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    setupViews()
  }

  private func setupViews() {
    addSubview(plusIcon)

    NSLayoutConstraint.activate([
      plusIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
      plusIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
}

