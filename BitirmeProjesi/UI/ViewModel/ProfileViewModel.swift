//
//  ProfileViewModel.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 8.10.2024.
//

import Foundation
import FirebaseAuth

//MARK: Profil sayfası için gerekli olan array içeriği, hesaptan çıkış ve kullanıcıAdı getirme
 
final class ProfileViewModel { //Profile TableView'da içerik olarak görüntülenecek kısımlar
    var userItems: [String] = [
        "Hesabım","Adreslerim","Geçmiş Siparişlerim","Ödeme Yöntemlerim","Canlı Destek","Çıkış Yap"
    ]
    
    func signOut(completion: @escaping (Error?) -> Void) { //Auth ile hesaptan çıkış
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error as NSError {
            completion(error)
        }
    }
    
    func bringUserName() -> String? {
        if let bringUserName = Auth.auth().currentUser?.email { //mevcut kullanıcı auth bilgisini alma
            let components = bringUserName.components(separatedBy: "@") //email'deki username kısmını getirme
            if components.count == 2 {
                var username = components[0]
                username = username.prefix(1).capitalized + username.dropFirst()
                return username
            }
        }
        return nil
    }
}
