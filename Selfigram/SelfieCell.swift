//
//  SelfieCell.swift
//  Selfigram
//
//  Created by Eventbase on 2018-10-15.
//  Copyright © 2018 Eventbase. All rights reserved.
//

import UIKit
import Parse

class SelfieCell: UITableViewCell {

    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!    
    @IBOutlet weak var commentLabel: UILabel!
    
    var post:Post? {
        
        // didSet is run when we set this variable in FeedViewController
        didSet{
            if let post = post {
                
                // I've added the below line to prevent flickering of images
                // This always resets the image to blank, waits for the image to download, and then sets it
                selfieImageView.image = nil
                
                let imageFile = post.image
                imageFile.getDataInBackground(block: {(data, error) -> Void in
                    if let data = data {
                        let image = UIImage(data: data)
                        self.selfieImageView.image = image
                    }
                })
                
                usernameLabel.text = post.user.username
                commentLabel.text = post.comment
                
            }
        }
    }
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
                sender.isSelected = !sender.isSelected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
