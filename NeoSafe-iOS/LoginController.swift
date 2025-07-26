import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var inicio: UIButton!
    @IBOutlet weak var contraseña: UITextField!
    @IBOutlet weak var correo: UITextField!
    
    @IBOutlet weak var viewcontraseña: UIView!
    @IBOutlet weak var viewcorreo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewcorreo.layer.cornerRadius = 20
        
        // Estilizar campo de correo
        correo.backgroundColor = UIColor(red: 0.85, green: 0.75, blue: 0.85, alpha: 0.5)
        correo.layer.cornerRadius = 20
        correo.textColor = .white
        correo.placeholder = "Correo Electrónico"
        correo.textAlignment = .center
        
        viewcontraseña.layer.cornerRadius = 20
        // Estilizar campo de contraseña
        contraseña.backgroundColor = UIColor(red: 0.85, green: 0.75, blue: 0.85, alpha: 0.5)
        contraseña.layer.cornerRadius = 20
        contraseña.textColor = .white
        contraseña.placeholder = "Contraseña"
        contraseña.textAlignment = .center
        contraseña.isSecureTextEntry = true
        contraseña.rightViewMode = .always
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.tintColor = .gray
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        contraseña.rightView = eyeButton
        
        // Estilizar botón Iniciar
        inicio.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.6, alpha: 1.0)
        inicio.layer.cornerRadius = 15
        inicio.setTitle("Iniciar", for: .normal)
        inicio.setTitleColor(UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0), for: .normal)
        
        // Agregar acción al botón
        inicio.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        contraseña.isSecureTextEntry.toggle()
        let imageName = contraseña.isSecureTextEntry ? "eye" : "eye.slash"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func loginButtonTapped() {
        guard let email = correo.text, !email.isEmpty,
              let password = contraseña.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Por favor, completa todos los campos")
            return
        }
        
        loginUser(email: email, password: password)
    }
    
    private func loginUser(email: String, password: String) {
        showLoading()
        
        // Debug: Imprimir lo que se está enviando
        print("🚀 Intentando login con:")
        print("Email: \(email)")
        print("Password: \(password)")
        
        APIService.shared.loginUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLoading()
                
                switch result {
                case .success(let response):
                    print("✅ Login exitoso: \(response)")
                    UserDefaults.standard.set(response.token, forKey: "auth_token")
                    UserDefaults.standard.set(response.user.id, forKey: "user_id")
                    
                    self?.showAlert(title: "¡Login Exitoso!", message: "Bienvenido \(response.user.name)") {
                        // Por ahora solo imprimir, quitar navegación
                        print("🎉 Debería navegar a Nueva Caja")
                    }
                case .failure(let error):
                    print("❌ Error de login: \(error)")
                    self?.showAlert(title: "Error de Login", message: "El login no fue exitoso. \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    private func showLoading() {
        inicio.setTitle("Ingresando...", for: .normal)
        inicio.isEnabled = false
    }
    
    private func hideLoading() {
        inicio.setTitle("Iniciar", for: .normal)
        inicio.isEnabled = true
    }
}
