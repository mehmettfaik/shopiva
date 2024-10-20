//
//  CartTableViewCell.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 9.10.2024.
//

import UIKit

//MARK: Sepetteki tableview'da listelenen ürünlerin bilgileri

final class CartTableViewCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pieceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
