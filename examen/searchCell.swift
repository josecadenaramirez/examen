//
//  searchCell.swift
//  examen
//
//  Created by José Cadena on 26/06/20.
//  Copyright © 2020 examen.com. All rights reserved.
//

import UIKit

class searchCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(search:History){
        lblTitle.text = search.name
    }

}
