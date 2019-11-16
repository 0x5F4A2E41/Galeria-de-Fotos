//
//  ImagePreviewVC.swift
//  Galeria de Fotos
//
//  Created by MacOS Mojave on 11/8/19.
//  Copyright © 2019 JAGS. All rights reserved.
//

import UIKit

class VistaPrevia: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var vistaFotos: UICollectionView!
    var arregloImagenes = [UIImage]()
    var contenido = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Se establece el color de fondo como negro cuando se muestra una imagen
        self.view.backgroundColor = UIColor.black
        
        //Layout donde se visualiza la imagen seleccionada
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        vistaFotos = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        vistaFotos.delegate = self
        vistaFotos.dataSource = self
        vistaFotos.register(vistaPreviaCompleta.self, forCellWithReuseIdentifier: "Cell")
        vistaFotos.isPagingEnabled = true
        vistaFotos.scrollToItem(at: contenido, at: .left, animated: true)
        
        //Se establece una sub vista para las fotos
        self.view.addSubview(vistaFotos)
        
        vistaFotos.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
    }
    
    //Función que verifica cuantas imagenes tiene el arreglo de imagenes
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arregloImagenes.count
    }
    
    //Función que verifica el lugar de las imagenes en el index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let lugarImagen = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! vistaPreviaCompleta
        lugarImagen.vistaImagen.image = arregloImagenes[indexPath.row]
        return lugarImagen
    }
    
    //Función que muestra las sub vistas como un flujo
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flujoLayout = vistaFotos.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flujoLayout.itemSize = vistaFotos.frame.size
        
        flujoLayout.invalidateLayout()
        
        vistaFotos.collectionViewLayout.invalidateLayout()
    }
    
    //Función que muestra un efecto de transición al seleccionar una imagen
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let cubrirContenido = vistaFotos.contentOffset
        let ancho  = vistaFotos.bounds.size.width
        
        let index = round(cubrirContenido.x / ancho)
        let cubrirNuevoContenido = CGPoint(x: index * size.width, y: cubrirContenido.y)
        
        vistaFotos.setContentOffset(cubrirNuevoContenido, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.vistaFotos.reloadData()
            
            self.vistaFotos.setContentOffset(cubrirNuevoContenido, animated: false)
        }, completion: nil)
    }
    
}

//Clase que muestra la imagen, opciones de zoom, escalado y gestos
class vistaPreviaCompleta: UICollectionViewCell, UIScrollViewDelegate {
    
    var imagenScroll: UIScrollView!
    var vistaImagen: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imagenScroll = UIScrollView()
        imagenScroll.delegate = self
        imagenScroll.alwaysBounceVertical = false
        imagenScroll.alwaysBounceHorizontal = false
        imagenScroll.showsVerticalScrollIndicator = true
        imagenScroll.flashScrollIndicators()
        imagenScroll.minimumZoomScale = 1.0
        imagenScroll.maximumZoomScale = 4.0
        
        //Constante que registra el numero de taps realizados
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(manejadorDoubleTap(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        imagenScroll.addGestureRecognizer(doubleTap)
        
        self.addSubview(imagenScroll)
        
        vistaImagen = UIImageView()
        vistaImagen.image = UIImage(named: "user")
        imagenScroll.addSubview(vistaImagen!)
        vistaImagen.contentMode = .scaleAspectFit
    }
    
    //Función que maneja el zoom del double tap
    @objc func manejadorDoubleTap(recognizer: UITapGestureRecognizer) {
        if imagenScroll.zoomScale == 1 {
            imagenScroll.zoom(to: zoomEscalado(scale: imagenScroll.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            imagenScroll.setZoomScale(1, animated: true)
        }
    }
    
    //Función que maneja el escalado del zoom
    func zoomEscalado(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoom = CGRect.zero
        zoom.size.height = vistaImagen.frame.size.height / scale
        zoom.size.width  = vistaImagen.frame.size.width  / scale
        
        let zoomCentrado = vistaImagen.convert(center, from: imagenScroll)
        zoom.origin.x = zoomCentrado.x - (zoom.size.width / 2.0)
        zoom.origin.y = zoomCentrado.y - (zoom.size.height / 2.0)
        
        return zoom
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.vistaImagen
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imagenScroll.frame = self.bounds
        vistaImagen.frame = self.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagenScroll.setZoomScale(1, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
