//
//  ProductsCollectionViewCell.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 9.10.2024.
//

import UIKit

//MARK: Anasayfa collectionview'da listelenen ürünler ve sepete ekleme butonu

final class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    var addButton: (() -> ())?
    
    @IBAction func addCartButton(_ sender: Any) {
        addButton?()
    }
}
