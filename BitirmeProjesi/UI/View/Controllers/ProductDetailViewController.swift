//
//  ProductDetailViewController.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 9.10.2024.
//

import UIKit
import Kingfisher
 
//MARK: Anasayfa'da ürünlerin üzerine basılınca açılan Detay ekranının özellikleri

final class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var pieceLabel: UILabel! //ürün fiyat
    
    
    @IBOutlet private weak var nameLabel: UILabel! //ürün ismi
    

    @IBOutlet weak var markaLabel: UILabel!
    
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var product: Products? //Model Products dosyasına köprü
    private var piece = 1
    private let viewModel = ProductDetailViewModel() //ProductDetailViewModel'a köprü
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProductName()
        setPriceAndPiece()
    }
    
    private func setProductName(){
        if let p = product {
            nameLabel.text = p.ad
            markaLabel.text = p.marka
            if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(p.resim)") {
                imageView.kf.setImage(with: url) //kf: KingFisher'dan nesne
            }
        }
    }
    private func setPriceAndPiece(){
        pieceLabel.text = String(piece)
        totalPriceLabel.text = "\(String(piece * product!.fiyat)) ₺"
    }
    
    @IBAction private func minusPlusButton(_ sender: UIButton) { //Detay'daki ürün adedi eksiltme artırma butonu
        if sender.tag == 0 {
            if piece > 0{
                piece -= 1
            }
        } else {
            piece += 1
        }
        pieceLabel.text = String(piece)
        totalPriceLabel.text = "\(String(piece *  product!.fiyat)) ₺" //eksi artıya göre label güncelleme
    }
    
    
    @IBAction private func addCartButton(_ sender: UIButton) {
        viewModel.addCart(
            ad: product!.ad,
            resim: product!.resim,
            kategori: product!.kategori,
            fiyat: product!.fiyat,
            marka: product!.marka, 
            siparisAdeti: piece,
            kullaniciAdi: "mehmet"  
        ) { _ in
            let alert = UIAlertController(title: "Sepet İşlemi", message: "Ürün başarıyla sepete eklendi.", preferredStyle: .alert)
            let okeyAction = UIAlertAction(title: "Tamam", style: .cancel)
            alert.addAction(okeyAction)
            self.present(alert, animated: true)
        }
    }

}
