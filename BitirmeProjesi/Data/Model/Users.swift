//
//  Users.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 8.10.2024.
//

import Foundation

class Users: Codable { //Codable: JSON cevabını liste olarak alma (özel model)
    let email: String
    let password: String
     
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
