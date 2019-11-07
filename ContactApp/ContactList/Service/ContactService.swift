//
//  ContactService.swift
//  ContactApp
//
//  Created by Nakama on 06/11/19.
//  Copyright © 2019 Ridho Pratama. All rights reserved.
//

import Foundation

enum ContactServiceError: Error {
    case missingData
}

protocol ContactService {
    func fetchContactList(completion: @escaping (Result<[Contact], Error>) -> Void)
}


class NetworkContactService: ContactService {
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    
    func fetchContactList(completion: @escaping (Result<[Contact], Error>) -> Void) {
        let url = URL(string: "https://gist.githubusercontent.com/99ridho/cbbeae1fa014522151e45a766492233c/raw/e3ea7cf52a7de7872863f9b2350f2c434eb0fe2c/contacts.json")!
        let task = URLSession.shared.dataTask(with: url) { [jsonDecoder] (data, response, error) in
            if let theError = error {
                completion(.failure(theError))
                return
            }
            
            guard let theData = data else {
                // do something when data is null
                completion(.failure(ContactServiceError.missingData))
                return
            }
            
            do {
                let response = try jsonDecoder.decode(ContactListResponse.self, from: theData)
                let contacts = response.data
                
//                DispatchQueue.main.async {
//                    self?.rawContacts = contacts
//                    self?.contactCellData = contacts.map {
//                        ContactListCellData(imageURL: $0.imageUrl, name: $0.name)
//                    }
//
//                    self?.tableView.reloadData()
//                }
                completion(.success(contacts))
            } catch (let decodeError) {
                // do something when failed response mapping
                completion(.failure(decodeError))
            }
        }
        
        task.resume()
    }

}
