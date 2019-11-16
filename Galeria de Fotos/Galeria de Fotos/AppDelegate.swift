//
//  AppDelegate.swift
//  Galeria de Fotos
//
//  Created by MacOS Mojave on 11/8/19.
//  Copyright © 2019 JAGS. All rights reserved.
//

import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Constante fotos que verifica la autorización
        let fotos = PHPhotoLibrary.authorizationStatus()
        
        //Si el permiso de fotos no esta determinado entonces verifica si esta autorizado o denegado
        if fotos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                
                //Si el status es autorizado entonces se ejecuta galeriaViewController()
                if status == .authorized {
                    self.galeriaViewController()
                
                //Si el status no está autorizado entonces envía un mensaje de alerta
                } else {
                    
                    //Se define la alerta y su contenido
                    let alerta = UIAlertController(
                        title: "Acceso Denegado",
                        message: "La aplicación necesita acceso a la galeria de fotos.",
                        preferredStyle: .alert)
                    
                    alerta.addAction(UIAlertAction(
                        title: "OK",
                        style: .default,
                        handler: nil))
                    
                    //Se define la ventana de la alerta
                    self.window?.rootViewController?.present(
                        alerta,
                        animated: true,
                        completion: nil)
                }
            })
            
        //Si el permiso de fotos esta autorizado entonces ejecuta la funcion galeriaViewController()
        } else if fotos == .authorized {
            galeriaViewController()
        }
        
        return true
    }
    
    //Función que ejecuta la vista principal de la aplicación
    func galeriaViewController() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            if let window = self.window {
                
                //Se establece un fondo de color blanco
                window.backgroundColor = UIColor.white
                
                let navegacion = UINavigationController()
                let vistaPrincipal = ViewController()
                
                //Se hace visible la vista principal
                navegacion.viewControllers = [vistaPrincipal]
                window.rootViewController = navegacion
                window.makeKeyAndVisible()
            }
        })
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
