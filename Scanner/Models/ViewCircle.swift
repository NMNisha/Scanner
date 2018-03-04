//
//  ViewCircle.swift
//  Scanner
//
//  Created by Nishanthini on 02/03/18.
//  Copyright © 2018 Nishanthini. All rights reserved.
//

import UIKit

@IBDesignable class ViewCircle: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            updateView()
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            updateView()
        }
    }
    func updateView() {
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = borderWidth
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: -2, height: 2)
        if shadowRadius == 0 {
            clipsToBounds = true
        } else {
            clipsToBounds = false
        }
        
    }
}
