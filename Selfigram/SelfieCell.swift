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
    
    var post:Post? {
        didSet{
            if let post = post {
                // I've added this line to prevent flickering of images
                // We are inside the cellForRowAtIndexPath method that gets called everytime we lay out a cell
                // This always resets the image to blank, waits for the image to download, and then sets it
                selfieImageView.image = nil
                
                let imageFile = post.image
                imageFile.getDataInBackground(block: { (data, error) -> Void in
                    if let data = data {
                        let image = UIImage(data: data)
                        self.selfieImageView.image = image
                    }
                })
                
                usernameLabel.text = post.user.username
                commentLabel.text = post.comment
                
                // set the likeButton defaulted to false
                likeButton.isSelected = false
                
                // query the likes property on post
                let query = post.likes.query()
                query.findObjectsInBackground(block: { (users, error) -> Void in
                    
                    if let users = users as? [PFUser]{
                        for user in users {
                            // If we find that the current user's objectId in our collection
                            // of likes we set the likeButton to selected
                            // objectId is a great way to compare if two objects are equal
                            if user.objectId == PFUser.current()?.objectId {
                                self.likeButton.isSelected = true
                            }
                        }
                    }
                })
                
            }
        }
    }
    
    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
            
        // Get rid of Optionals
        if let post = post,
            let user = PFUser.current() {
            
            if sender.isSelected {
                post.likes.add(user)
                
                // We have modified the likes property on post. We must now save it to Parse
                post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        print("like from user successfully saved")
                        
                        // Creating an row in the Activity table
                        // Saving it as a "like" type
                        let activity = Activity(type: "like", post: post, user: user)
                        activity.saveInBackground(block: { (success, error) -> Void in
                            print("activity successfully saved")
                        })
                        
                        
                    }else{
                        print("error is \(error)")
                    }
                })
                }
            else { // like button has been deselected and we should remove the like
                
                // PFRelation also has a useful method called removeObject that removes
                // the element if there is an element to be removed.
                post.likes.remove(user)
                post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        print("like from user successfully removed")
                        
                        //PFQuery to find the like activity
                        if let activityQuery = Activity.query(){
                            activityQuery.whereKey("post", equalTo: post)
                            activityQuery.whereKey("user", equalTo: user)
                            activityQuery.whereKey("type", equalTo: "like")
                            activityQuery.findObjectsInBackground(block: { (activities, error) -> Void in
                                
                                
                                // You should only have one like activity from a user
                                // but this is code is being safe and checking for one or multiple instances
                                // and then deleting all of them
                                if let activities = activities {
                                    for activity in activities {
                                        activity.deleteInBackground(block: { (success, error) -> Void in
                                            print("deleted activity")
                                        })
                                    }
                                }
                            })
                        }
                        
                    }else{
                        print("error is \(error)")
                    }
                })
                
            }
        }
    }
}
