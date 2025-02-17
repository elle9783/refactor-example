//
//  ContactListVIewModel.swift
//  ContactApp
//
//  Created by Nakama on 06/11/19.
//  Copyright © 2019 Ridho Pratama. All rights reserved.
//

import Foundation
import UIKit

class ContactListViewModel : NSObject {
    private let service: ContactService
    
    private var rawContacts: [Contact] = []
    private var contactCellData: [ContactListCellData] = []
    
    var onError : ((Error) -> Void)?
    //handle when data received
    var onDataReceived : (() -> Void)?
    
    init(service: ContactService = NetworkContactService()) {
        self.service = service
    }
    
    func fetchContactList() {
        service.fetchContactList { [weak self] (result) in
            switch result {
//            case let .success(contacts): //style 1
//            case .success: //style 2
            case .success(let contacts): //style 3
                self?.rawContacts = contacts
                self?.contactCellData = contacts.map {
                    ContactListCellData(imageURL: $0.imageUrl, name: $0.name)
                }
                self?.onDataReceived?()
            case let .failure(error):
                self?.onError?(error)
            }
        }
    }
}

extension ContactListViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = contactCellData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactListTableViewCell.reuseIdentifier) as! ContactListTableViewCell
        cell.configureCell(with: cellData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
