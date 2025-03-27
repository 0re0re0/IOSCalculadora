//
//  AppDelegate.swift
//  Calculadora
//
//  Created by Javier Cardenas Perdomo on 25/3/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Setup
        
        setupView()
        return true
    }
    
    
    // MARK: Metodos privados
    
    private func setupView() {
        
        //instanciamos UIWindow para mostrar el contenido de la homeviewcontroller
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = HomeViewController()
        // el controlador de vista principal es nuestro homeviewcontroller
        window?.rootViewController = vc
        // hacer que se mantenga visible
        window?.makeKeyAndVisible()
    }

}

