//
//  ViewController.swift
//  Galeria de Fotos
//
//  Created by MacOS Mojave on 11/8/19.
//  Copyright © 2019 JAGS. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var vistaFotos: UICollectionView!
    var arregloImagenes = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Título mostrado dentro de la aplicación
        self.title = "Galeria de Fotos"
        
        //Layout prinicpal donde se muestra la cuadricula de fotos
        let layout = UICollectionViewFlowLayout()
        
        vistaFotos = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        vistaFotos.delegate = self
        vistaFotos.dataSource = self
        vistaFotos.register(itemFoto.self, forCellWithReuseIdentifier: "Cell")
        
        vistaFotos.backgroundColor = UIColor.white
        
        self.view.addSubview(vistaFotos)
        
        vistaFotos.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
        
        //Se ejecuta la función obtenerFotos()
        obtenerFotos()
    }
    
    //Función que verifica cuantas imagenes tiene el arreglo de imagenes
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arregloImagenes.count
    }
    
    //Función que verifica el lugar de las imagenes en el index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let lugarImagen = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! itemFoto
        lugarImagen.imagen.image = arregloImagenes[indexPath.item]
        return lugarImagen
    }
    
    //Función que muestra una vista previa de la imagen
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vistaPrevia = VistaPrevia()
        vistaPrevia.arregloImagenes = self.arregloImagenes
        vistaPrevia.contenido = indexPath
        self.navigationController?.pushViewController(vistaPrevia, animated: true)
    }
    
    //Función que cambia el tamaño de la imagen dependiendo de la orientación del dispositivo
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        
        if Orientacion.TipoOrientacion.isPortrait {
            return CGSize(width: width / 4 - 1, height: width / 4 - 1)
        } else {
            return CGSize(width: width / 6 - 1, height: width / 6 - 1)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        vistaFotos.collectionViewLayout.invalidateLayout()
    }
    
    //Función que modifica el espaciado entre las imagenes
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    //Función que modifica el interlineado de las imagenes
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    //Función donde se obtienen las imagenes de la galeria de fotos del dispositivo
    func obtenerFotos(){
        
        arregloImagenes = []
        
        DispatchQueue.global(qos: .background).async {
            
            //Constante que administra las iamgenes
            let administradorImagenes = PHImageManager.default()
            
            //Constante que solicita las imagenes de forma sincrona y en alta calidad
            let solicitarImagenes = PHImageRequestOptions()
            solicitarImagenes.isSynchronous = true
            solicitarImagenes.deliveryMode = .highQualityFormat
            
            //Constante que obtiene las imagenes por fecha de creación y de forma descendente
            let obtenerImagenes = PHFetchOptions()
            obtenerImagenes.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
            
            //Constante que obtiene las imagenes
            let resultadoImagenes: PHFetchResult = PHAsset.fetchAssets(with: .image, options: obtenerImagenes)
            
            //Si el resultado es mayor a cero se obtiene todas las imagenes de la galeria de fotos
            if resultadoImagenes.count > 0 {
                for i in 0..<resultadoImagenes.count{
                    administradorImagenes.requestImage(for: resultadoImagenes.object(at: i) as PHAsset, targetSize: CGSize(width:500, height: 500),contentMode: .aspectFill, options: solicitarImagenes, resultHandler: { (image, error) in
                        self.arregloImagenes.append(image!)
                    })
                }
                
            //Si el resultado es cero entonces muestra el siguiente mensaje
            } else {
                print("No tienes fotos.")
            }
            
            //Método que recarga las imagenes en la aplicación
            DispatchQueue.main.async {
                self.vistaFotos.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//Clase donde al seleccionar la imagen se escala en automático
class itemFoto: UICollectionViewCell {
    
    var imagen = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imagen.contentMode = .scaleAspectFill
        imagen.clipsToBounds = true
        self.addSubview(imagen)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imagen.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) no ha sido implementado")
    }
    
}

//Struct donde se verifica la orientación
struct Orientacion {
    struct TipoOrientacion {
        
        //Verifica si la orientación es Landscape
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isLandscape
                    : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        
        //Verifica si la orientación es Portrait
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isPortrait
                    : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
}
