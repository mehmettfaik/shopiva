//
//  CartViewModel.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 8.10.2024.
//

import Foundation
import UIKit
import RxSwift

//MARK: Sepet ekranı görünümü için repo'dan çağırılacak fonksiyonlar
 
final class CartViewModel{
    private let repository = ProductsRepository()
    var productList = BehaviorSubject<[CartProducts]>(value: [CartProducts]())
    var totalPrice = BehaviorSubject<Int>(value: Int())

    init() {
        productList = repository.cartProductsList
        totalPrice = repository.totalPrice
    }
    
    func bringCartProducts(kullaniciAdi: String) {
        repository.bringCartProducts(kullaniciAdi: kullaniciAdi)
    }
    
    func deleteCartProducts(sepetId: Int, kullaniciAdi: String) {
        repository.deleteProducts(sepetId: sepetId, kullaniciAdi: kullaniciAdi)
    }
}
