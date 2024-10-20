//
//  CartProducts.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 8.10.2024.
//

import Foundation

 class CartProducts: Codable{ //Codable: JSON cevabını liste olarak alma (özel model)
    let sepetId: Int
    let ad: String
    let resim: String
    let kategori: String
    let fiyat: Int
    let marka: String
    let siparisAdeti: Int
    let kullaniciAdi: String
     
     init(sepetId: Int, ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String) {
         self.sepetId = sepetId
         self.ad = ad
         self.resim = resim
         self.kategori = kategori
         self.fiyat = fiyat
         self.marka = marka
         self.siparisAdeti = siparisAdeti
         self.kullaniciAdi = kullaniciAdi
     }
    
  
}
