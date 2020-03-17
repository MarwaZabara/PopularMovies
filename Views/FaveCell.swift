//
//  FaveCellTableViewCell.swift
//  PopularMovies
//
//  Created by Marwa Zabara on 3/17/20.
//  Copyright © 2020 Marwa Zabara. All rights reserved.
//

import UIKit

class FaveCell: UITableViewCell {
    
    @IBOutlet weak var YearTxt: UILabel!
    @IBOutlet weak var NameTxt: UILabel!
    @IBOutlet weak var Img: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
