//
//  ViewController.swift
//  2 Filozop
//
//  Created by Dasha Filozop on 11.03.2025.
//
// Repository: https://github.com/filozopdasha/RedditApp

import Foundation
import UIKit
import Kingfisher

class PostDetailsViewController: UIViewController {
    private var redditPost: RedditPost?
    
    @IBOutlet weak private var Username: UILabel!
    @IBOutlet weak private var Domain: UILabel!
    @IBOutlet weak private var LargeText: UILabel!
    @IBOutlet weak private var Numc: UIButton!
    @IBOutlet weak private var SavedButton: UIButton!
    @IBOutlet weak private var Num: UIButton!
    @IBOutlet weak private var PostImage: UIImageView!
    @IBOutlet weak private var TimeCreated: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIAppearance() 
    }
    
    func config(with post: RedditPost) {
        self.redditPost = post
    }
    
    private func UIAppearance() {
        guard let post = redditPost else { return }
        Username.text = post.author_fullname
        Domain.text = post.domain
        LargeText.text = post.title
        Numc.setTitle(post.num_comments.description, for: .normal)
        
        let num = Int.random(in: 1...2)
        if num == 1 {
            SavedButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else if num == 2 {
            SavedButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
        let res = post.ups + post.downs
        Num.setTitle("\(res)", for: .normal)
        
        guard let imgUrl = post.url_overridden_by_dest, let imageUrl = URL(string: imgUrl) else {
            PostImage.isHidden = true
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
        
        TimeCreated.text = timePast
        PostImage.kf.setImage(with: imageUrl)
    }
}
