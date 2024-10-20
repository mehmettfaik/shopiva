//
//  ProductsRepository.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 8.10.2024.
//

import Foundation
import RxSwift
import Alamofire
import UIKit
import FirebaseFirestore
import FirebaseAuth

//MARK: Ortak kullanım için oluşturulan metodların yer aldığı sınıf 
final class ProductsRepository {
    var productsList = BehaviorSubject<[Products]>(value: [Products]())
    var cartProductsList = BehaviorSubject<[CartProducts]>(value: [CartProducts]())
    var totalPrice = BehaviorSubject<Int>(value: Int())
    
    //MARK: Tüm ürünleri listele - yükle fonksiyonu
    func loadProducts() {
        let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
        AF.request(url, method: .get).response { response in
            if let data = response.data {
                do{
                    let response = try JSONDecoder().decode(ProductsResponse.self, from: data)
                    if let list = response.urunler {
                        self.productsList.onNext(list)
                    }
                }catch{
                    print("ürün listeleme hatası")
                }
            }
        }
    }
    
    //MARK: Sepete ürün ekleme
    func addCart(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String, completion: @escaping (Bool) -> Void) {
        bringCartProducts(kullaniciAdi: kullaniciAdi) { existingCartProducts, error in
            if let existingCartProducts = existingCartProducts {
                // Sepette bu ürün var mı kontrol et
                if let existingProduct = existingCartProducts.first(where: { $0.ad == ad }) {
                    // Sepette aynı ürün var, sil ve yeni adetle ekle
                    self.deleteProducts(sepetId: Int(exactly: existingProduct.sepetId)!, kullaniciAdi: kullaniciAdi)
                    
                    // Ardından yeni sipariş adetini ekle
                    let newAdet = existingProduct.siparisAdeti + siparisAdeti
                    let params: [String: Any] = [
                        "ad": ad,
                        "resim": resim,
                        "kategori": kategori,
                        "fiyat": fiyat,
                        "marka": marka,
                        "siparisAdeti": newAdet,
                        "kullaniciAdi": kullaniciAdi
                    ]
                    let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
                    AF.request(url, method: .post, parameters: params).response { response in
                        switch response.result {
                        case .success(_):
                            completion(true)
                        case .failure(_):
                            completion(false)
                        }
                    }
                } else {
                    // Sepette yoksa, yeni ekle
                    let params: [String: Any] = [
                        "ad": ad,
                        "resim": resim,
                        "kategori": kategori,
                        "fiyat": fiyat,
                        "marka": marka,
                        "siparisAdeti": siparisAdeti,
                        "kullaniciAdi": kullaniciAdi
                    ]
                    let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
                    AF.request(url, method: .post, parameters: params).response { response in
                        switch response.result {
                        case .success(_):
                            completion(true)
                        case .failure(_):
                            completion(false)
                        }
                    }
                }
            } else {
                completion(false) // Hata durumu
            }
        }
    }

    
    //MARK: Sepetten ürün silme ve total ücreti güncelleme
    func deleteProducts(sepetId: Int, kullaniciAdi: String) {
        let params: Parameters = ["sepetId": sepetId, "kullaniciAdi": kullaniciAdi]
        let url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php"
        AF.request(url,method: .post,parameters: params).response { response in
            if let data = response.data {
                do{
                    _ = try JSONDecoder().decode(CartResponse.self, from: data)
                    self.bringCartProducts(kullaniciAdi: kullaniciAdi) { _ , error in
                        if error != nil {
                            self.totalPrice.onNext(0)
                        } else {
                        }
                    }
                }catch{
                    print("sepetten ürün silme hatası")
                }
            }
        }
    }
    
    func bringCartProducts(kullaniciAdi: String) {
        var amount = 0
        let params: Parameters = ["kullaniciAdi": kullaniciAdi]
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
        
        AF.request(url, method: .post, parameters: params).responseData { response in
            switch response.result {
            case .success(let data):
//                print("Raw response data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
                
                do {
                    let response = try JSONDecoder().decode(CartProductsResponse.self, from: data)
                    if let list = response.urunler_sepeti {
                        self.cartProductsList.onNext(list)
                        for urun in list {
                            amount += Int(exactly: urun.siparisAdeti)! * Int(exactly: urun.fiyat)!
                            self.totalPrice.onNext(amount)
                        }
//                        print("Successfully parsed cart products: \(list)")
                    } else {
//                        print("urunler_sepeti is nil in the response")
                    }
                } catch {
                    print("JSON Decoding Error: \(error)")
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .keyNotFound(let key, let context):
                            print("Key '\(key)' not found: \(context.debugDescription)")
                        case .valueNotFound(let value, let context):
                            print("Value '\(value)' not found: \(context.debugDescription)")
                        case .typeMismatch(let type, let context):
                            print("Type '\(type)' mismatch: \(context.debugDescription)")
                        case .dataCorrupted(let context):
                            print("Data corrupted: \(context.debugDescription)")
                        @unknown default:
                            print("Unknown decoding error")
                        }
                    }
                }
            case .failure(let error):
                print("Network Error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: Sepetteki ürünleri getirme işlemi - adet ve kullanıcı adı güncelleme
//    func bringCartProducts(kullaniciAdi: String) {
//        var amount = 0
//        let params: Parameters = ["kullaniciAdi": kullaniciAdi]
//        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
//        AF.request(url, method: .post, parameters: params).response { response in
//            if let data = response.data {
//                do {
//                    let response = try JSONDecoder().decode(CartProductsResponse.self, from: data)
//                    if let list = response.urunler_sepeti {
//                        print("Sepetteki ürünler: \(list)")
//                        self.cartProductsList.onNext(list)
//                    } else {
//                        print("Sepet boş ya da veriler alınamadı.")
//                    }
//                } catch {
//                    print("Hata: \(error)")
//                }
//            } else {
//                print("Veri alınamadı, response: \(response)")
//            }
//        }
//        }
//    

    
    //MARK: Alamofire sayesinde ürün arama - veri çekme işlemi
    func searchProducts(aramaKelimesi:String){
        var searchProducts = [Products]()
        if aramaKelimesi != "" {
            let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
            AF.request(url, method: .get).response { response in
                if let data = response.data {
                    do{
                        let response = try JSONDecoder().decode(ProductsResponse.self, from: data)
                        if let list = response.urunler {
                            for products in list {
                                if products.ad.contains(aramaKelimesi) {
                                    searchProducts.append(products)
                                }
                            }
                            self.productsList.onNext(searchProducts)
                        }
                    }catch{
                        print("tüm ürünler getirilirken hata")
                    }
                }
            }
        } else {
            loadProducts()
        }
    }
    
    
    //MARK: Auth ile kullanıcı giriş işlemi ve Service'ye aktarma - karşılaştırma
    func signUp(email: String?, password: String?, completion: @escaping (Bool) -> Void) {
        if let mail = email, let password = password {
            let user = Users(email: mail, password: password)
            let data = ["email": user.email, "password": user.password]
            Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
                if error == nil {
                    let myUsers = Firestore.firestore()
                    let userCollection = myUsers.collection("Users").document(authResult?.user.uid ?? "").collection(user.email)
                    userCollection.document("UserInfo").setData(data) { error in
                        if error != nil {
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
    //MARK: Auth ile kullanıcı giriş işlemi ve Service'ye aktarma - karşılaştırma
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _ , error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: Ürünleri kategorilere ayırmak için tüm ürünleri getirme
    func categorizedList(listContens: [String]) {
        let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
        AF.request(url, method: .get).response { response in
            if let data = response.data {
                do {
                    let response = try JSONDecoder().decode(ProductsResponse.self, from: data)
                    if let list = response.urunler {
                        let filteredList = list.filter { product in
                            return listContens.contains(String(product.id))
                        }
                        self.productsList.onNext(filteredList)
                    }
                } catch {
                    print("kategorideki tüm ürünleri getirirken hata")
                }
            }
        }
    }
    
    //MARK: Sepetteki ürünleri çekme (post)
//    func bringCartProducts(kullaniciAdi: String, completion: @escaping([CartProducts]?, Error?) -> Void) {
//        var amount = 0
//        let params: Parameters = ["kullaniciAdi": kullaniciAdi]
//        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
//        AF.request(url, method: .post, parameters: params).response { response in
//            if let data = response.data {
//                do {
//                    let response = try JSONDecoder().decode(CartProductsResponse.self, from: data)
//                    if let list = response.urunler_sepeti {
//                        self.cartProductsList.onNext(list)
//                        for urun in list {
//                            amount += Int(exactly: urun.siparisAdeti)! * Int(exactly: urun.fiyat)!
//                            self.totalPrice.onNext(amount)
//                        }
//                        completion(list, nil)
//                    }
//                } catch {
//                    print("sepetteki urun getirme hatası")
//                    completion(nil, error)
//                }
//            }
//        }
//    }

//    //MARK: Sepetteki ürünleri çekme (post)
    func bringCartProducts(kullaniciAdi: String, completion: @escaping([CartProducts]?, Error?) -> Void) {
        let params: Parameters = ["kullaniciAdi": kullaniciAdi]
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
        
        // Boş sepet durumunda kullanılacak default değerler
        func returnEmptyCart() {
            self.cartProductsList.onNext([])
            self.totalPrice.onNext(0)
            completion([], nil)
        }
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: URLEncoding.default)
            .responseData { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let data):
                    // Boş response kontrolü
                    guard !data.isEmpty else {
                        returnEmptyCart()
                        return
                    }
                    
                    // JSON decode
                    do {
                        let response = try JSONDecoder().decode(CartProductsResponse.self, from: data)
                        if let list = response.urunler_sepeti, !list.isEmpty {
                            let totalAmount = list.reduce(0) { $0 + ($1.siparisAdeti * $1.fiyat) }
                            self.cartProductsList.onNext(list)
                            self.totalPrice.onNext(totalAmount)
                            completion(list, nil)
                        } else {
                            returnEmptyCart()
                        }
                    } catch {
                        print("Decoding Error: \(error)")
                        returnEmptyCart()
                    }
                    
                case .failure(let error):
                    print("Network Error: \(error)")
                    returnEmptyCart()
                }
        }
    }
//
    //MARK: Kullanıcı bilgilerinin Firestore service'den çekme
    private func fetchUserData(completion: @escaping (Users) -> Void) {
        let myUsers = Firestore.firestore()
        if let user = Auth.auth().currentUser {
            let userCollection = myUsers.collection("Users").document(user.uid).collection(user.email!).document("UserInfo")
            userCollection.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let userData = document.data() {
                        if let email = userData["email"] as? String, let password = userData["password"] as? String {
                            let user = Users(email: email, password: password)
                            completion(user)
                        }
                    }
                } else {
                    print("kullanıcı bilgisi çekme hatası")
                }
            }
        }
    }
}
