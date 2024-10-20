//
//  CartProductsResponse.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 8.10.2024.
//

import Foundation

final class CartProductsResponse: Codable{ //Codable: JSON cevabını liste olarak alma
    let urunler_sepeti: [CartProducts]?
    let success: Int?
}

