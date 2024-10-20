//
//  HomeViewModel.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 8.10.2024.
//

import Foundation
import RxSwift
import UIKit
 
//MARK: iş mantığı ve veri yönetimini sağlar. Verilerin güncel kalması sapğlanır.

//MARK: Anasayfa görünümü için repo'dan çağırılacak fonksiyonlar
 
final class HomeViewModel{
    private let repository = ProductsRepository() //köprü
    //BehaviorSubject RXSwift ile çalışan veri aktarımına ve yüklemeye yardımcı bir nesne
    var productList = BehaviorSubject<[Products]>(value: [Products]())
    private var orderQuantity = BehaviorSubject<Int>(value: 1)
    private var cartProductList = BehaviorSubject<[CartProducts]>(value: [CartProducts]())
    
    //ürünlerin gruplarına göre ID verildi
    let teknoloji = ["1", "3", "6", "7"]
    let aksesuar = ["2", "5", "9", "12"]
    let kozmetik = ["4", "8","10","11"]
    
    init() {
        productList = repository.productsList //ürün listesi initialization
    }
    
    func loadProducts() { //ürünleri yükleme repo dan çağırma
        repository.loadProducts()
    }
    
    func searchProducts(aramaKelimesi: String) { //ürünleri harfe göre arama repo dan çağırma
        repository.searchProducts(aramaKelimesi: aramaKelimesi)
    }
    
    func segmentedProductList(idList: [String]){ //segment kontrolü ve kategorileme repo dan çağırılması
        repository.categorizedList(listContens: idList)
    }
    private func uploadProducts(){ // ürünleri güncelleme repodan çağırma
        repository.loadProducts()
    }
}
