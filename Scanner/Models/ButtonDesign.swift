//
//  ButtonDesign.swift
//  Scanner
//
//  Created by Nishanthini on 02/03/18.
//  Copyright © 2018 Nishanthini. All rights reserved.
//

import UIKit

@IBDesignable class ButtonDesign: UIButton {
        
        @IBInspectable var cornerRadius: CGFloat = 0 {
            didSet {
                updateView()
            }
        }
        @IBInspectable var borderWidth: CGFloat = 0 {
            didSet {
                updateView()
            }
        }
        @IBInspectable var borderColor: UIColor? {
            didSet {
                updateView()
            }
        }
        @IBInspectable var shadowColor: UIColor? {
            didSet {
                updateView()
            }
        }
        @IBInspectable var shadowRadius: CGFloat = 0.0 {
            didSet {
                updateView()
            }
        }
        @IBInspectable var shadowOffsetWidth: Int = 0 {
            didSet {
                updateView()
            }
        }
        @IBInspectable var shadowOffsetHeight: Int = 0 {
            didSet {
                updateView()
            }
        }
        func updateView() {
            layer.cornerRadius = cornerRadius
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = borderWidth
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowRadius = shadowRadius
            layer.shadowOpacity = 1
            layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
            clipsToBounds = false
        }
    }

