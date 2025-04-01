//
//  PostView.swift
//  2 Filozop
//
//  Created by Dasha Filozop on 29.03.2025.
//

import Foundation
import UIKit
import Kingfisher


class PostView: UIView{
    let kCONTENT_XIB_NAME = "PostView"

    
    @IBOutlet var contentView: UIView!
    

    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var timeCreatedLabel: UILabel!
    
        
    @IBOutlet weak var domainLabel: UILabel!
    
    @IBOutlet weak var savedButton: UIButton!
    
    @IBOutlet weak var largeTitleLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var ratingButton: UIButton!
    
    @IBOutlet weak var commentsButton: UIButton!
    
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func shareFunc(_ sender: Any) {
        guard let post = currentPost else { return }
        actionSheet(for: post)
    }
    func actionSheet(for post: RedditPost) {
        let url = "https://www.reddit.com\(post.permalink)/"
        guard let data = URL(string: url) else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    
    @IBAction func saveFunc(_ sender: Any) {
        guard var post = currentPost else { return }
        
        post.toggleSaved()
        
        let imageName: String
        if post.saved {
            imageName = "bookmark.fill"
        } else {
            imageName = "bookmark"
        }
        savedButton.setImage(UIImage(systemName: imageName), for: .normal)
        currentPost = post
        
        var savedPosts = FileStorage.shared.fetchPosts() ?? []
        
        if post.saved {
            if !savedPosts.contains(where: { $0.permalink == post.permalink }) {
                savedPosts.append(post)
            }
        } else {
            savedPosts.removeAll { $0.permalink == post.permalink }
        }
        
        FileStorage.shared.save(postList: savedPosts)
        
    }
    
    private func savePostState(post: RedditPost) {
        var savedPosts = UserDefaults.standard.array(forKey: "savedPosts") as? [String] ?? []
        
        if post.saved {
            if !savedPosts.contains(post.permalink) {
                savedPosts.append(post.permalink)
            }
        } else {
            savedPosts.removeAll { $0 == post.permalink }
        }
        
        UserDefaults.standard.set(savedPosts, forKey: "savedPosts")
    }
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
            contentView.fixInView(self)
        }
    private var currentPost: RedditPost?
    
    func prepareForReuse() {
        postImage.kf.cancelDownloadTask()
        postImage.image = nil 
        postImage.isHidden = false
        
    }

    func setup(post: RedditPost) {
        self.currentPost = post
        usernameLabel.text = post.author_fullname
        domainLabel.text = post.domain
        largeTitleLabel.text = post.title
        commentsButton.setTitle(post.num_comments.description, for: .normal)
        
        var savedPosts = FileStorage.shared.fetchPosts() ?? []
        if savedPosts.contains(where: { $0.permalink == post.permalink }) {
            post.saved = true
        }
        
        if post.saved {
            savedButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            savedButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
        
        let res = post.ups + post.downs
        ratingButton.setTitle("\(res)", for: .normal)
        
        guard let imgUrl = post.url_overridden_by_dest, let imageUrl = URL(string: imgUrl) else {
            postImage.isHidden = true
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
        
        timeCreatedLabel.text = timePast
        postImage.kf.setImage(with: imageUrl)
        
    }
    
    
    
    
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}


