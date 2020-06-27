//
//  itemCell.swift
//  examen
//
//  Created by José Cadena on 26/06/20.
//  Copyright © 2020 examen.com. All rights reserved.
//

import UIKit

class itemCell: UITableViewCell {

    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgItem: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(item:item){
        imgItem.downloadWithLoader(url: item.img)
        lblTitle.text = item.name
        lblPrice.text = "Precio: $\(item.price)"
        lblLocation.text = "Ubicación: \(item.location)"
    }

}
