//
//  ProductsResponse.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 8.10.2024.
//

import Foundation

// MARK: Apiden gelen ürünlerle ilgili JSON cevabını modellemek için kullanılır

final class ProductsResponse: Codable{ //Codable: JSON cevabını liste olarak alma
    let urunler: [Products]?
    let success :Int?
}
