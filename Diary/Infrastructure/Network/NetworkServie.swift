//
//  NetworkServie.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

protocol NetworkService {

    typealias CompletionHandler = (Result<Data, NetworkError>) -> Void

    func request(endpoint: EndPoint, completion: @escaping CompletionHandler)
}

final class DefaultNetworkService: NetworkService {

    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    private func fetchData(url: URL, completion: @escaping CompletionHandler) {
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestFailError))
                return
            }

            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode)  else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                completion(.failure(.httpResponseError(code: statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.noDataError))
                return
            }

            completion(.success(data))
        }.resume()
    }
}

extension DefaultNetworkService {

    func request(endpoint: EndPoint, completion: @escaping CompletionHandler) {
        do {
            let url = try endpoint.url()
            fetchData(url: url) { result in
                completion(result)
            }
        } catch {
            completion(.failure(.requestFailError))
        }
    }
}

enum NetworkError: Error {

    case requestFailError
    case httpResponseError(code: Int)
    case noDataError
    case generateUrlFailError
}
