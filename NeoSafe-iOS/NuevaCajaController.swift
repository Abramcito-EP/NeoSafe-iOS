import UIKit

class NuevaCajaController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nuevacaja: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.frame = view.bounds
        backgroundGradient.colors = [UIColor(hex: "#0000").cgColor]
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(backgroundGradient, at: 0)

        let buttonGradient = CAGradientLayer()
        buttonGradient.frame = nuevacaja.bounds
        buttonGradient.colors = [UIColor(hex: "#9C27B0").cgColor, UIColor(hex: "#42104A").cgColor]
        buttonGradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        buttonGradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        buttonGradient.cornerRadius = 15
        if let existingLayer = nuevacaja.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            existingLayer.removeFromSuperlayer()
        }
        nuevacaja.layer.insertSublayer(buttonGradient, at: 0)
        nuevacaja.layer.cornerRadius = 15
        nuevacaja.setTitle("Nueva Caja", for: .normal)
        nuevacaja.setTitleColor(.white, for: .normal)
        nuevacaja.addTarget(self, action: #selector(showNewBoxModal), for: .touchUpInside)

        nuevacaja.addTarget(self, action: #selector(updateGradientFrame), for: .touchUpInside)
    }

    @objc func updateGradientFrame() {
        if let gradientLayer = nuevacaja.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            gradientLayer.frame = nuevacaja.bounds
        }
        if let backgroundGradient = view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            backgroundGradient.frame = view.bounds
        }
    }

    @objc func showNewBoxModal() {
        nuevacaja.isHidden = true

        let modalVC = UIViewController()
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.view.backgroundColor = .clear

        let containerView = UIView()
        containerView.backgroundColor = .clear
        let containerGradient = CAGradientLayer()
        containerGradient.colors = [UIColor(hex: "#9C27B0").cgColor, UIColor(hex: "#42104A").cgColor]
        containerGradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        containerGradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        containerGradient.cornerRadius = 20

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        containerView.frame = CGRect(x: (screenWidth - 250) / 2, y: (screenHeight - 250) / 2, width: 250, height: 250)
        containerGradient.frame = containerView.bounds
        containerView.layer.insertSublayer(containerGradient, at: 0)

        let nameLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 210, height: 30))
        nameLabel.text = "Nombre:"
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.font = .boldSystemFont(ofSize: 20)

        let boxNameField = UITextField(frame: CGRect(x: 20, y: 60, width: 210, height: 40))
        boxNameField.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        boxNameField.layer.cornerRadius = 20
        boxNameField.textColor = .white
        boxNameField.placeholder = "Nombre de la caja"
        boxNameField.textAlignment = .center
        boxNameField.borderStyle = .none
        boxNameField.returnKeyType = .done
        boxNameField.delegate = self

        let passwordLabel = UILabel(frame: CGRect(x: 20, y: 110, width: 210, height: 30))
        passwordLabel.text = "Contraseña:"
        passwordLabel.textColor = .white
        passwordLabel.textAlignment = .center
        passwordLabel.font = .boldSystemFont(ofSize: 20)

        let passwordField = UITextField(frame: CGRect(x: 20, y: 150, width: 210, height: 40))
        passwordField.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        passwordField.layer.cornerRadius = 20
        passwordField.textColor = .white
        passwordField.placeholder = "Contraseña"
        passwordField.textAlignment = .center
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .none
        passwordField.returnKeyType = .done
        passwordField.delegate = self

        let closeButton = UIButton(frame: CGRect(x: (250 - 50) / 2, y: 210, width: 50, height: 30))
        closeButton.setTitle("OK", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor(hex: "#9C27B0")
        closeButton.layer.cornerRadius = 10
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        containerView.addGestureRecognizer(tapGesture)

        containerView.addSubview(nameLabel)
        containerView.addSubview(boxNameField)
        containerView.addSubview(passwordLabel)
        containerView.addSubview(passwordField)
        containerView.addSubview(closeButton)

        modalVC.view.addSubview(containerView)

        present(modalVC, animated: true)
    }

    @objc func closeModal() {
        view.endEditing(true)
        if let modalVC = presentedViewController {
            modalVC.dismiss(animated: true) {
                // Redirigir a EstadoController
                if let estadoVC = self.storyboard?.instantiateViewController(withIdentifier: "EstadoController") as? EstadoController {
                    estadoVC.modalPresentationStyle = .fullScreen
                    self.present(estadoVC, animated: true, completion: nil)
                }
            }
        }
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
