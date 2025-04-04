//
//  UiButtonExtension.swift
//  Calculadora
//
//  Created by Javier Cardenas Perdomo on 26/3/25.
//

import UIKit

let softBlue = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 0.3)
let blue = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)

extension UIButton {
    
    // Redondeo boton
    func round() {
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
    
    // Brillo boton
    func shine() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }) { (completion) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            })
        }
    }
    
    func selectOperation(_ selected: Bool) {
        let isDarkMode = self.traitCollection.userInterfaceStyle == .dark
        let normalColor = isDarkMode ?
            UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0) :
            UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        let selectedColor = isDarkMode ?
            UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 0.3) :
            UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 0.3)
        
        backgroundColor = selected ? selectedColor : normalColor
        setTitleColor(.white, for: .normal)
    }
}
