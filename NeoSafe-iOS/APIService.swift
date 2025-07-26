import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "http://localhost:3333/api"
    
    private init() {}
    
    // MARK: - Register User
    func registerUser(name: String, lastName: String, email: String, password: String, completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/register") else {
            print("❌ URL inválida: \(baseURL)/auth/register")
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("🌐 URL creada: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Crear fecha de nacimiento por defecto (puedes cambiar esto después)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let defaultBirthDate = dateFormatter.string(from: Date(timeIntervalSince1970: 631152000)) // 1990-01-01
        
        let body = [
            "name": name,
            "lastName": lastName,
            "email": email,
            "password": password,
            "birthDate": defaultBirthDate
        ]
        
        print("📦 Body a enviar: \(body)")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            print("✅ JSON serializado correctamente")
        } catch {
            print("❌ Error serializando JSON: \(error)")
            completion(.failure(error))
            return
        }
        
        print("🚀 Enviando petición...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("📡 Respuesta recibida")
            
            if let error = error {
                print("❌ Error de red: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Respuesta no es HTTP")
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            print("📊 Status code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                print("❌ No hay datos en la respuesta")
                completion(.failure(APIError.noData))
                return
            }
            
            print("📄 Datos recibidos: \(String(data: data, encoding: .utf8) ?? "No se puede convertir a string")")
            
            if httpResponse.statusCode == 201 {
                do {
                    let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    print("✅ Decodificación exitosa")
                    completion(.success(registerResponse))
                } catch {
                    print("❌ Error decodificando respuesta exitosa: \(error)")
                    completion(.failure(error))
                }
            } else {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    print("❌ Error del servidor: \(errorResponse.message)")
                    completion(.failure(APIError.serverError(errorResponse.message)))
                } catch {
                    print("❌ Error decodificando respuesta de error: \(error)")
                    completion(.failure(APIError.serverError("Error desconocido")))
                }
            }
        }.resume()
    }
    
    // MARK: - Login User
    func loginUser(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "email": email,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            if httpResponse.statusCode == 200 {
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    completion(.success(loginResponse))
                } catch {
                    completion(.failure(error))
                }
            } else {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    completion(.failure(APIError.serverError(errorResponse.message)))
                } catch {
                    completion(.failure(APIError.serverError("Credenciales inválidas")))
                }
            }
        }.resume()
    }
}

// MARK: - Models
struct RegisterResponse: Codable {
    let message: String
    let user: User
}

struct LoginResponse: Codable {
    let token: String
    let user: User
}

struct User: Codable {
    let id: Int
    let name: String
    let lastName: String
    let email: String
    let birthDate: String?
    let role: Role?
    let roleId: Int?
    let createdAt: String?
    let updatedAt: String?
    let password: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, role, roleId, createdAt, updatedAt, password
        case lastName = "lastName"  // ← Cambiar de "last_name" a "lastName"
        case birthDate = "birthDate" // ← También cambiar de "birth_date" a "birthDate"
    }
}

struct Role: Codable {
    let id: Int
    let name: String
}

struct ErrorResponse: Codable {
    let message: String
}

// MARK: - Errors
enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case invalidResponse
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .noData:
            return "No se recibieron datos"
        case .invalidResponse:
            return "Respuesta inválida del servidor"
        case .serverError(let message):
            return message
        }
    }
}