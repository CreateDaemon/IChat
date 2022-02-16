//
//  GradientView.swift
//  IChat
//
//  Created by Дмитрий Межевич on 15.02.22.
//

import UIKit


class GradientView: UIView {
    
    enum Point {
        case topLeading
        case leading
        case bottomLeading
        case top
        case center
        case bottom
        case topTrailing
        case trailing
        case bottomTrailing
        
        var point: CGPoint {
            switch self {
            case .topLeading:
                return CGPoint(x: 0, y: 0)
            case .leading:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeading:
                return CGPoint(x: 0, y: 1)
            case .top:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottom:
                return CGPoint(x: 0.5, y: 1)
            case .topTrailing:
                return CGPoint(x: 1, y: 0)
            case .trailing:
                return CGPoint(x: 1, y: 0.5)
            case .bottomTrailing:
                return CGPoint(x: 1, y: 1)
            }
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(from: Point, to: Point, startColor: UIColor?, endColor: UIColor?) {
        self.init()
        setupGradientView(from: from, to: to, startColor: startColor, endColor: endColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
}

extension GradientView {
    
    private func setupGradientView(from: Point, to: Point, startColor: UIColor?, endColor: UIColor?) {
        layer.addSublayer(gradientLayer)
        gradientLayer.startPoint = from.point
        gradientLayer.endPoint = to.point
        setupGradientColor(startColor: startColor, endColor: endColor)
    }
            
    private func setupGradientColor(startColor: UIColor?, endColor: UIColor?) {
        if let startColor = startColor, let endColor = endColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
}
