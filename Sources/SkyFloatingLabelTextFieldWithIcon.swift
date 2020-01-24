//  Copyright 2016-2019 Skyscanner Ltd
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in
//  compliance with the License. You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software distributed under the License is
//  distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and limitations under the License.

import UIKit

public protocol SkyFloatingButtonTapped: class {
  func buttonDidTapped(_ sender: UIButton)
}

open class SkyFloatingLabelTextFieldWithIcon: SkyFloatingLabelTextField {
  
  open weak var buttonDelegate: SkyFloatingButtonTapped?
  
  open lazy var iconImageView: UIImageView = {
    let iconImageView = UIImageView()
    iconImageView.backgroundColor = .clear
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
    return iconImageView
  }()
  
  open lazy var leftButton: UIButton = {
    let button = UIButton()
    button.setTitle(nil, for: .normal)
    button.contentHorizontalAlignment = .fill
    button.contentVerticalAlignment = .fill
    button.imageView?.contentMode = .scaleAspectFit
    return button
  }()
  
  /// A UIImage value that determines the image that the icon is using
  @IBInspectable
  dynamic open var iconImage: UIImage? {
    didSet {
      addIconImageView()
      iconImageView.image = iconImage
    }
  }
  
  @IBInspectable
  dynamic open var leftButtonIconImage: UIImage? {
    didSet {
      addButtonView()
      leftButton.setImage(leftButtonIconImage, for: .normal)
    }
  }
  
  /// A Bool value that determines if the UIImage should be templated or not
  @IBInspectable
  dynamic open var templateImage: Bool = true {
    didSet {
      if templateImage {
        let templatedOriginalImage = self.iconImageView.image?
          .withRenderingMode(.alwaysTemplate)
        self.iconImageView.image = templatedOriginalImage
      }
    }
  }
  
  @IBInspectable
  dynamic open var iconColor: UIColor = UIColor.gray {
    didSet {
      updateImageViewTintColor()
    }
  }
  
  @IBInspectable
  dynamic open var selectedIconColor: UIColor = UIColor.gray {
    didSet {
      updateImageViewTintColor()
    }
  }
  
  @IBInspectable
  dynamic open var iconWidth: CGFloat = 20 {
    didSet {
      updateFrame()
    }
  }
  
  /**
   A float value that determines the left margin of the icon.
   Use this value to position the icon more precisely horizontally.
   */
  @IBInspectable
  dynamic open var iconMarginLeft: CGFloat = 4 {
    didSet {
      updateFrame()
    }
  }
  
  /**
   A float value that determines the rotation in degrees of the icon.
   Use this value to rotate the icon in either direction.
   */
  @IBInspectable
  open var iconRotationDegrees: Double = 0 {
    didSet {
      iconImageView.transform = CGAffineTransform(rotationAngle: CGFloat(iconRotationDegrees * .pi / 180.0))
    }
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
//    createIconImageView()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
//    createIconImageView()
  }
  
  // MARK: Creating the icon image view
  
  /// Creates the icon image view
  fileprivate func addIconImageView() {
    self.templateImage = true
    addSubview(self.iconImageView)
  }
  
  fileprivate func addButtonView() {
    addSubview(self.leftButton)
    leftButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)

  }
  
  override open func updateColors() {
    super.updateColors()
    if self.templateImage {
      updateImageViewTintColor()
    }
  }
  
  @objc fileprivate func buttonAction(_ sender: UIButton!) {
    buttonDelegate?.buttonDidTapped(sender)
  }
  
  fileprivate func updateImageViewTintColor() {
    if !isEnabled {
      iconImageView.tintColor = disabledColor
    } else if hasErrorMessage {
      iconImageView.tintColor = errorColor
    } else {
      iconImageView.tintColor = editingOrSelected ? selectedIconColor : iconColor
    }
  }

  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    var rect = super.textRect(forBounds: bounds)
    guard iconImage != nil else { return rect }
    
    if iconImage != nil {
      rect.origin.x += CGFloat(iconWidth + iconMarginLeft)
      rect.size.width -= CGFloat(iconWidth + iconMarginLeft)
    }
    
    if leftButtonIconImage != nil {
      rect.size.width -= CGFloat(iconWidth / 1.5)
    }
    
    return rect
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    var rect = super.editingRect(forBounds: bounds)
    guard iconImage != nil else { return rect }
    
    if iconImage != nil {
      rect.origin.x += CGFloat(iconWidth + iconMarginLeft)
      rect.size.width -= CGFloat(iconWidth + iconMarginLeft)
    }
    
    if leftButtonIconImage != nil {
      rect.size.width -= CGFloat(iconWidth / 1.5)
    }

    return rect
  }
  
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    var rect = super.placeholderRect(forBounds: bounds)
    
    if iconImage != nil {
      rect.origin.x += CGFloat(iconWidth + iconMarginLeft)
      rect.size.width -= CGFloat(iconWidth + iconMarginLeft)
    }
    
    if leftButtonIconImage != nil {
      rect.size.width -= CGFloat(iconWidth / 1.5)
    }
    
    return rect
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    updateFrame()
  }
  
  fileprivate func updateFrame() {
    let textWidth: CGFloat = bounds.size.width
    
    if iconImage != nil {
      iconImageView.frame = CGRect(
        x: 0,
        y: titleLabel.frame.size.height,
        width: iconWidth,
        height: lineView.frame.origin.y - titleLabel.frame.size.height
      )
    }
    
    if leftButtonIconImage != nil {
      leftButton.frame = CGRect(
        x: textWidth - iconWidth,
        y: titleLabel.frame.size.height,
        width: iconWidth / 1.5,
        height: lineView.frame.origin.y - titleLabel.frame.size.height
      )
    }
    
  }
}
