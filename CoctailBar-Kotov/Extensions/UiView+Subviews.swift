//
//  UiView+Subviews.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 15.07.2022.
//

import UIKit

extension UIView {

  func addSubviews(_ views: UIView...) {
    views.forEach { addSubview($0) }
  }

  func addSubviews(_ views: [UIView]) {
    views.forEach { addSubview($0) }
  }

}
