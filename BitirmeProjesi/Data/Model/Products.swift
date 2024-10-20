//
//  Products.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 8.10.2024.
//

import Foundation

class Products: Codable { //Codable: bilgileri JSON formatında almak için 
    let id: Int
    let ad: String
    let resim: String
    let kategori: String
    let fiyat: Int
    let marka: String

    init(id: Int, ad: String, resim: String, kategori: String, fiyat: Int, marka: String) {
        self.id = id
        self.ad = ad
        self.resim = resim
        self.kategori = kategori
        self.fiyat = fiyat
        self.marka = marka
    }
}

