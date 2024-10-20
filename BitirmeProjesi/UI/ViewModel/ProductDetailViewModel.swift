//
//  ProductDetailViewModel.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 8.10.2024.
//

import Foundation
import UIKit
import RxSwift
  
//MARK: Detay sayfa görünümü için repo'dan çağırılacak addCart fonksiyonu

final class ProductDetailViewModel{
    private let repository = ProductsRepository()
    
    func addCart(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String, completion: @escaping (Bool) -> Void) {
        repository.addCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: "mehmet") { success in
            completion(success)
        }
        }
    }

