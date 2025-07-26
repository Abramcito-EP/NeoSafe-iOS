import UIKit

class EstadoController: BaseMenuController {
    
    @IBOutlet weak var agregar: UIButton!
    @IBOutlet weak var notificaciones: UIButton!
    @IBOutlet weak var perfil: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        agregar.addTarget(self, action: #selector(showNewBoxModal), for: .touchUpInside)
       
    }
    
    func setupUI() {
        view.backgroundColor = .black
        
        // Calcular el centro vertical
        let screenHeight = view.bounds.height
        let totalHeight: CGFloat = 50 + 30 + 30 + 50 + 40 // Altura total de los elementos + espaciado
        let startY = (screenHeight - totalHeight) / 2
        
        // Estado de la caja
        let estadoLabel = UILabel()
        estadoLabel.text = "Estado de la caja: ACTIVO"
        estadoLabel.textColor = .white
        estadoLabel.textAlignment = .center
        estadoLabel.font = .boldSystemFont(ofSize: 20)
        estadoLabel.backgroundColor = UIColor(hex: "#9C27B0")
        estadoLabel.layer.cornerRadius = 15
        estadoLabel.clipsToBounds = true
        estadoLabel.frame = CGRect(x: (view.bounds.width - 250) / 2, y: startY, width: 250, height: 50)
        
        // Temperatura Interna
        let tempLabel = UILabel()
        tempLabel.text = "Temperatura Interna: 22°C - Seguro"
        tempLabel.textColor = .white
        tempLabel.font = .systemFont(ofSize: 16)
        tempLabel.textAlignment = .center
        tempLabel.frame = CGRect(x: (view.bounds.width - 250) / 2, y: startY + 70, width: 250, height: 30)
        
        // Humedad
        let humLabel = UILabel()
        humLabel.text = "Humedad: 30% - Adecuado"
        humLabel.textColor = .white
        humLabel.font = .systemFont(ofSize: 16)
        humLabel.textAlignment = .center
        humLabel.frame = CGRect(x: (view.bounds.width - 250) / 2, y: startY + 110, width: 250, height: 30)
        
        // Botón Open the box
        let openButton = UIButton()
        openButton.setTitle("open the box", for: .normal)
        openButton.setTitleColor(.white, for: .normal)
        openButton.backgroundColor = UIColor(hex: "#9C27B0")
        openButton.layer.cornerRadius = 15
        openButton.frame = CGRect(x: (view.bounds.width - 200) / 2, y: startY + 160, width: 200, height: 50)
        
        // Añadir subvistas
        view.addSubview(estadoLabel)
        view.addSubview(tempLabel)
        view.addSubview(humLabel)
        view.addSubview(openButton)
    }
    
    @objc func showNewBoxModal() {
        if let nuevaCajaVC = storyboard?.instantiateViewController(withIdentifier: "NuevaCajaController") as? NuevaCajaController {
            nuevaCajaVC.modalPresentationStyle = .fullScreen
            present(nuevaCajaVC, animated: true, completion: nil)
        }
    }
    
}
