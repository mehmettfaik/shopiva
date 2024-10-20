//
//  Extensions.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 9.10.2024.
//

import Foundation
import UIKit
 
//MARK: Home CollectionView (collectionview'da ürünlerin listelenmesi ve sepete ekleme işlemi)
// varolan sınıfları genişletmek için kullanırız. Yazdığımız kodu daha modüler hale getirir

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductsCollectionViewCell
        let urun = productList[indexPath.row]
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(urun.resim)") {
            cell.imageView.kf.setImage(with: url)
        }
        cell.nameLabel.text = urun.ad
        cell.priceLabel.text = "\(urun.fiyat) ₺"
        cell.addButton = {[unowned self] in
            let chosenProduct = productList[indexPath.row]
            detailViewModel.addCart(
                ad: chosenProduct.ad,
                resim: chosenProduct.resim,
                kategori: chosenProduct.kategori, fiyat: Int(exactly: chosenProduct.fiyat)!,
                marka: chosenProduct.marka, siparisAdeti: 1,
                kullaniciAdi: "mehmet"
            )  { _ in
                let alert = UIAlertController(title: "Sepet", message: "Ürün başarıyla sepete eklendi.", preferredStyle: .alert)
                let okeyAction = UIAlertAction(title: "Tamam", style: .cancel)
                alert.addAction(okeyAction)
                self.present(alert, animated: true)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urun = productList[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: urun)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//MARK: SearchBar (tüm ürünler arasından harf odaklı arama işlemi)
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchProducts(aramaKelimesi: searchText)
    }
}

//MARK: Cart TableView (sepetteki ürünlerin tableview'da listelenmesi ve silme işlemi)
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartViewCell", for: indexPath) as! CartTableViewCell
        let product = productList[indexPath.row]

        let piecePrice = product.fiyat
        let orderPiece = product.siparisAdeti
        cell.priceLabel.text = "\(piecePrice * orderPiece) ₺"

        cell.pieceLabel.text = "\(product.siparisAdeti) adet"
        cell.productNameLabel.text = product.ad

        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(product.resim)") {
            cell.productImageView.kf.setImage(with: url)
        }

        return cell
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = self.productList[indexPath.row]
            self.viewModel.deleteCartProducts(sepetId: Int(exactly: product.sepetId)!, kullaniciAdi: product.kullaniciAdi)
            self.productList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let alert = UIAlertController(title: "Silme İşlemi", message: "Ürün başarılı bir şekilde sepetten silindi.", preferredStyle: .alert)
            let okeyAction = UIAlertAction(title: "Tamam", style: .cancel)
            alert.addAction(okeyAction)
            self.present(alert, animated: true)
        }
    }
}

//MARK: Profile TableView (kullanıcının profil bilgilerinin listelenmesi ve çıkış yapma işlemi)
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        cell.cellLabel.text = viewModel.userItems[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            logOutOfAccount()
        }
    }
}

