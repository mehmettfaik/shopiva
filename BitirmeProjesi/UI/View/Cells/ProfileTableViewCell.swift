//
//  ProfileTableViewCell.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 9.10.2024.
//

import UIKit

//MARK: Kullanıcı tableview'da cell içerisinde bulunan label ve seçili ürün işlemi
  
final class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
