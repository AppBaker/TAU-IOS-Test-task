//
//  UIImage+Extension.swift
//  TAU IOS Test task
//
//  Created by Ivan Nikitin on 29.11.2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
