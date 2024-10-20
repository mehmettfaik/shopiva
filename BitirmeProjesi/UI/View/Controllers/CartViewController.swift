//
//  CartViewController.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 9.10.2024.
//

import UIKit
import RxSwift

//MARK: Sepet Ekranı özellikleri

final class CartViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cartTotalLabel: UILabel! //sepetteki toplam fiyat
    let viewModel = CartViewModel() //CartViewModel'a köprü
    var productList = [CartProducts]() //CartProducts'a köprü
    private var totalPrice = 0 //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setProductList()
        setTotalPrice()
    }
    
    private func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func setProductList(){
        _ = viewModel.productList.subscribe(onNext: { list in //bir arkaplan iş parçacığı var yani ürün listemin yüklenmesini istiyorum
            self.productList = list
            DispatchQueue.main.async {
                self.tableView.reloadData() //hata ne olursa olsun içerikleri gönder reloadData()
            }
        })
    }
    private func setTotalPrice(){
        _ = viewModel.totalPrice.subscribe(onNext: { total in //bir arkaplan iş parçacığı var toplam fiyatın listemin yüklenmesini istiyorum
            self.totalPrice = total
            DispatchQueue.main.async {
                self.cartTotalLabel.text = "\(String(self.totalPrice)) ₺" //hata ne olursa olsun içerikleri gönder reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) { //kullanıcı adına göre ürünleri getir
        viewModel.bringCartProducts(kullaniciAdi: "mehmet")
    }
    
    @IBAction private func satinAlPressed(_ sender: UIButton) { //Satın Al butonu tıklanması ve uyarılar
        let alert = UIAlertController(title: "Satın Alma", message: "Ürünler başarıyla sipariş verildi. En kısa sürede kargo takip numaranız sms ile gönderilecek, iyi günler.", preferredStyle: .alert)
        let okeyAction = UIAlertAction(title: "Tamam", style: .cancel){ _ in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            self.present(controller, animated: true, completion: nil)
        }
        alert.addAction(okeyAction)
        self.present(alert, animated: true)
    }
}
