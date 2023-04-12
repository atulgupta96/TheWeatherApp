//
//  APIRouter.swift
//  ProjectMVVM
//
//  Created by Atul Gupta on 04/01/23.
//

import Foundation

//MARK: - GenericAPIErrors
enum GenericAPIErrors: Error {
    case invalidAPIResponse
    case decodingError
    
    var message: String {
        switch self {
        case .invalidAPIResponse: return "The page you’re requesting appears to be stuck in traffic. Refresh to retrieve!"
        case .decodingError: return "Our servers started speaking a language we are yet to learn. Bear with us."
        }
    }
}


struct APIRouter<T: Codable> {
    
    //MARK: - Private Variables
    private let session: URLSessionProtocol
    
    //MARK: - Init
    init(_ session: URLSessionProtocol) {
        self.session = session
    }
    
    //MARK: API Request
    func request(_ router: Routable,
                        completion : @escaping (_ model : T?, _ statusCode: Int? , _ error : Error?) -> Void ) {
        let queue = DispatchQueue(label: "Atul's-Network-Thread", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .workItem, target: .none)
        queue.async {
            let task = self.session.dataTask(with: router.request) { (data, response, error) in
                DispatchQueue.main.async {
                    if let httpResponse = response as? HTTPURLResponse {
                        self.curateResponseForUI(router, data, httpResponse.statusCode, error, completion: completion)
                    } else {
                        self.curateResponseForUI(router, data, nil, error, completion: completion)
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Curate response for app/analytics
    func curateResponseForUI(_ router: Routable, _ data: Data?, _ statusCode: Int?, _ error: Error?, completion : @escaping (_ model : T?, _ statusCode: Int? , _ error : Error?) -> Void) {
        print("\n\nurl: \(router.url), \nheaders: \(router.headers), \ncode: \(String(describing: statusCode))\nbody: \(String(describing: RawJSONOverHTTP.jsonFrom(data: router.body)))")
        
        guard error == nil, let code = statusCode, (200..<300) ~= code else {
            completion(nil, statusCode, GenericAPIErrors.invalidAPIResponse)
            return
            //TODO: - Send proper error codable if error structure of backend is common
        }
        
        guard let properData = data else {
            completion(nil, statusCode, GenericAPIErrors.invalidAPIResponse)
            return
        }
        
        print("response: \(String(describing: RawJSONOverHTTP.jsonFrom(data: properData)))")
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let model = try decoder.decode(T.self, from: properData)
            completion(model, statusCode,  nil)
            
        } catch let error {
            debugPrint(error.localizedDescription)
            completion(nil, statusCode, GenericAPIErrors.decodingError)
        }
    }
}

//MARK: - URLSessionProtocol
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

//MARK: - URLSessionDataTaskProtocol
protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
