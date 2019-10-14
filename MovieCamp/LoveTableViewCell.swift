//
//  LoveTableViewCell.swift
//  MovieCamp
//
//  Created by Julia Wang on 2019/10/8.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import UIKit

class LoveTableViewCell: UITableViewCell {

    @IBOutlet weak var loveMovieImage: UIImageView!
    @IBOutlet weak var loveMovieTitleLabel: UILabel!
    @IBOutlet weak var loveMovieReleaseDateLabel: UILabel!
    @IBOutlet weak var loveMovieVoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
