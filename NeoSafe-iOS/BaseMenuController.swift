import UIKit

class BaseMenuController: UIViewController {

    @IBOutlet weak var menu: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        menu?.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
    }

    @objc func showMenu() {
        let menuAlert = UIAlertController(title: "Menú", message: "Selecciona una opción", preferredStyle: .actionSheet)

        let titleAttr = NSAttributedString(string: "Menú", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let messageAttr = NSAttributedString(string: "Selecciona una opción", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        menuAlert.setValue(titleAttr, forKey: "attributedTitle")
        menuAlert.setValue(messageAttr, forKey: "attributedMessage")

        // Monitoreo
        let monitoreo = UIAlertAction(title: "📡 Monitoreo", style: .default) { _ in
            self.presentController(withId: "MonitoreoController")
        }

        // Gráficas
        let graficas = UIAlertAction(title: "📊 Gráficas", style: .default) { _ in
            self.presentController(withId: "GraficasController")
        }

        // Seguridad
        let seguridad = UIAlertAction(title: "🔐 Seguridad", style: .default) { _ in
            self.presentController(withId: "SeguridadController")
        }

        // Documentos
        let documentos = UIAlertAction(title: "📁 Documentos", style: .default) { _ in
            self.presentController(withId: "DocumentosController")
        }

        // Cancelar
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel)
        cancelar.setValue(UIColor(hex: "#710078"), forKey: "titleTextColor")

        // Colores
        [monitoreo, graficas, seguridad, documentos].forEach {
            $0.setValue(UIColor.white, forKey: "titleTextColor")
            menuAlert.addAction($0)
        }

        menuAlert.addAction(cancelar)

        present(menuAlert, animated: true) {
            let subview = self.view.subviews.first
            let alertContentView = subview?.subviews.first?.subviews.first?.subviews.first
            alertContentView?.backgroundColor = UIColor(hex: "#000000")
        }
    }

    func presentController(withId id: String) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: id) {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}
