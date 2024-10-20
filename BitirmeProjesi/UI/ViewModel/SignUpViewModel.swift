//
//  SignUpViewModel.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 8.10.2024.
//

import Foundation
import FirebaseAuth

//MARK: Kayıt ekranı için repodan func çekme ve kayıt metodu oluşturma

final class SignUpViewModel{
    private let repository = ProductsRepository()
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        repository.signUp(email: email, password: password) { sonuc in
            completion(sonuc)
        }
    }
}
