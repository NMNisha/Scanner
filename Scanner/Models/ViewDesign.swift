//
//  ViewDesign.swift
//  Scanner
//
//  Created by Nishanthini on 02/03/18.
//  Copyright © 2018 Nishanthini. All rights reserved.
//


import UIKit

@IBDesignable class ViewDesign: UITextField {
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var isShowImage: Bool = false {
        didSet {
            updateView()
        }
    }
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
        clipsToBounds = false
        if isShowImage {
            if let image = rightImage {
                rightViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.image = image
                
                var width = rightPadding + 20
                
                if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line {
                    width = width + 5
                }
                let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
                view.addSubview(imageView)
                rightView = view
            } else {
                rightViewMode = .never
            }
        }
    }
    
}
