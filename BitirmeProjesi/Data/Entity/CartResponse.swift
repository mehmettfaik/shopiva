//
//  CartResponse.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 8.10.2024.
//

import Foundation

final class CartResponse: Codable{ //Codable: JSON cevabını liste olarak alma
    let success: Int?
    let message: String?
}

