//
//  PostTableViewCell.swift
//  2 Filozop
//
//  Created by Dasha Filozop on 18.03.2025.
//

import Foundation
import UIKit
import Kingfisher

class PostTableViewCell: UITableViewCell {
    private var redditPost: RedditPost?
    
    @IBOutlet weak private var UsernameCell: UILabel!
    @IBOutlet weak private var DomainCell: UILabel!
    @IBOutlet weak private var LargeTitleCell: UILabel!
    @IBOutlet weak private var NumcCell: UIButton!
    @IBOutlet weak private var SavedButtonCell: UIButton!
    @IBOutlet weak private var NumCell: UIButton!
    @IBOutlet weak private var PostImageCell: UIImageView!
    @IBOutlet weak private var TimeCreatedCell: UILabel!
    
    func config(with post: RedditPost) {
        self.redditPost = post
        
        UsernameCell.text = post.author_fullname
        DomainCell.text = post.domain
        LargeTitleCell.text = post.title
        NumcCell.setTitle(post.num_comments.description, for: .normal)
        
        let num = Int.random(in: 1...2)
        if num == 1 {
            SavedButtonCell.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else  if num == 2 {
            SavedButtonCell.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
        let res = post.ups + post.downs
        NumCell.setTitle("\(res)", for: .normal)
        
        
        guard let imgUrl = post.url_overridden_by_dest, let imageUrl = URL(string: imgUrl) else {
            PostImageCell.isHidden = true
            self.layoutIfNeeded()
            return
        }
        
        var timePast: String {
            let currDate = Date()
            let postDate = Date(timeIntervalSince1970: TimeInterval(post.created))
            let timeInterval = currDate.timeIntervalSince(postDate)
            
            let seconds = Int(timeInterval)
            let minutes = seconds / 60
            let hours = minutes / 60
            let days = hours / 24
            
            if seconds < 60 {
                return "\(seconds)s"
            } else if minutes < 60 {
                return "\(minutes)m"
            } else if hours < 24 {
                return "\(hours)h"
            } else {
                return "\(days)d"
            }
        }
        
        TimeCreatedCell.text = timePast
        PostImageCell.isHidden = false
        PostImageCell.kf.setImage(with: imageUrl)
        self.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.PostImageCell.image = nil
    }
}
