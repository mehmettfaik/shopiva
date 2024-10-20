//
//  SignInViewModel.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 8.10.2024.
//

import Foundation
import FirebaseAuth
 
//MARK: Giriş ekranı için repodan func çekme ve giriş metodu oluşturma

final class SignInViewModel{
    private let repository = ProductsRepository()
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        repository.signIn(email: email, password: password) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
