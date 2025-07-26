//
//  ViewController.swift
//  NeoSafe-iOS
//
//  Created by mac on 18/07/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var caja: UIImageView!
    @IBOutlet weak var carga: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 🔄 Animación tipo gif para 'carga'
        var imagenesAnimacion: [UIImage] = []
        
        for i in 1...118 {
            let nombre = "pattern-19443_512_30ms_\(i)"
            if let imagen = UIImage(named: nombre) {
                imagenesAnimacion.append(imagen)
            } else {
                print("❌ No se encontró la imagen: \(nombre)")
            }
        }
        
        carga.animationImages = imagenesAnimacion
        carga.animationDuration = 3.5
        carga.animationRepeatCount = 0
        carga.startAnimating()
        
        // 💥 Animación rebote de 'caja'
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       options: [.repeat, .autoreverse],
                       animations: {
            self.caja.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
        
        // ✨ Parpadeo suave
        UIView.animate(withDuration: 1.2,
                       delay: 0,
                       options: [.repeat, .autoreverse],
                       animations: {
            self.caja.alpha = 0.5
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Cambia "Main" si es necesario
            
            if let registroVC = storyboard.instantiateViewController(withIdentifier: "RegistroController") as? RegistroController {
                registroVC.modalPresentationStyle = .fullScreen
                self.present(registroVC, animated: true, completion: nil)
            } else {
                print("❌ No se pudo instanciar RegistroController desde storyboard")
            }
        }
    }
}
