import UIKit

class RegistroController: UIViewController {

    @IBOutlet weak var registrarse: UIButton!
    @IBOutlet weak var contraseña: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var Nombre: UITextField!
    @IBOutlet weak var apellido: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Ocultar teclado al tocar fuera
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        // Configurar fondo negro
        view.backgroundColor = .black

        // Estilizar campo de correo
        correo.backgroundColor = UIColor(red: 0.85, green: 0.75, blue: 0.85, alpha: 0.5)
        correo.layer.cornerRadius = 15
        correo.textColor = UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0)
        correo.placeholder = "Correo Electrónico"
        correo.textAlignment = .center

        // Estilizar campo de nombre
        Nombre.backgroundColor = UIColor(red: 0.85, green: 0.75, blue: 0.85, alpha: 0.5)
        Nombre.layer.cornerRadius = 15
        Nombre.textColor = UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0)
        Nombre.placeholder = "Nombre"
        Nombre.textAlignment = .center

        // Estilizar campo de apellido
        apellido.backgroundColor = UIColor(red: 0.85, green: 0.75, blue: 0.85, alpha: 0.5)
        apellido.layer.cornerRadius = 15
        apellido.textColor = UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0)
        apellido.placeholder = "Apellido"
        apellido.textAlignment = .center

        // Estilizar campo de contraseña
        contraseña.backgroundColor = UIColor(red: 0.85, green: 0.75, blue: 0.85, alpha: 0.5)
        contraseña.layer.cornerRadius = 15
        contraseña.textColor = UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0)
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

        // Estilizar botón Registrarse
        registrarse.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.6, alpha: 1.0)
        registrarse.layer.cornerRadius = 15
        registrarse.setTitle("Registrarse", for: .normal)
        registrarse.setTitleColor(UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0), for: .normal)

        // Agregar acción al botón
        registrarse.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }

    @objc func togglePasswordVisibility(_ sender: UIButton) {
        contraseña.isSecureTextEntry.toggle()
        let imageName = contraseña.isSecureTextEntry ? "eye" : "eye.slash"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func registerButtonTapped() {
        // Ocultar teclado al presionar el botón
        view.endEditing(true)

        print("🔥 Botón de registro presionado")

        guard let name = Nombre.text, !name.isEmpty,
              let lastName = apellido.text, !lastName.isEmpty,
              let email = correo.text, !email.isEmpty,
              let password = contraseña.text, !password.isEmpty else {
            print("❌ Campos vacíos")
            showAlert(title: "Error", message: "Por favor, completa todos los campos")
            return
        }

        print("📝 Datos ingresados:")
        print("Nombre: \(name)")
        print("Apellido: \(lastName)")
        print("Email: \(email)")
        print("Password: \(password)")

        if !isValidEmail(email) {
            print("❌ Email inválido: \(email)")
            showAlert(title: "Error", message: "Por favor, ingresa un email válido")
            return
        }

        if password.count < 6 {
            print("❌ Contraseña muy corta: \(password.count) caracteres")
            showAlert(title: "Error", message: "La contraseña debe tener al menos 6 caracteres")
            return
        }

        print("✅ Validaciones pasadas, iniciando registro...")
        registerUser(name: name, lastName: lastName, email: email, password: password)
    }

    private func registerUser(name: String, lastName: String, email: String, password: String) {
        showLoading()

        print("🚀 Intentando registro con:")
        print("Nombre: \(name)")
        print("Apellido: \(lastName)")
        print("Email: \(email)")
        print("Password: \(password)")

        APIService.shared.registerUser(name: name, lastName: lastName, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLoading()

                switch result {
                case .success(let response):
                    print("✅ Registro exitoso: \(response)")
                    self?.showAlert(title: "¡Registro Exitoso!", message: "Bienvenido \(response.user.name)") {
                        print("🎉 Debería navegar a Nueva Caja")
                    }
                case .failure(let error):
                    print("❌ Error de registro: \(error)")
                    self?.showAlert(title: "Error de Registro", message: "El registro no fue exitoso. \(error.localizedDescription)")
                }
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }

    private func showLoading() {
        registrarse.setTitle("Registrando...", for: .normal)
        registrarse.isEnabled = false
    }

    private func hideLoading() {
        registrarse.setTitle("Registrarse", for: .normal)
        registrarse.isEnabled = true
    }

    // 👉 Método para ocultar teclado al tocar fuera
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
