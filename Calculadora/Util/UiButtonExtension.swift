//
//  UiButtonExtension.swift
//  Calculadora
//
//  Created by Javier Cardenas Perdomo on 26/3/25.
//

import UIKit

let softBlue = UIColor(red: 24/255, green: 78/255, blue: 104/255, alpha: 0.3)
let blue = UIColor(red: 24/255, green: 78/255, blue: 104/255, alpha: 1.0)

extension UIButton{
    
    // Redondeo boton
    func round() {
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
    
    // Brillo boton
    func shine() {
        UIView.animate(withDuration: 0.1, animations:  {
            self.alpha = 0.5
        }) { (completion) in
            UIView.animate(withDuration: 0.1, animations:  {
                self.alpha = 1
            })
        }
    }
    
    func selectOperation(_ selected: Bool) {
        let softBlue = UIColor(red: 24/255, green: 78/255, blue: 104/255, alpha: 0.3) 
        backgroundColor = selected ? softBlue : blue
        setTitleColor(selected ? .white : .white, for: .normal)
    }
}

