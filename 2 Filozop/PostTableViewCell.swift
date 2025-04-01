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
    
    
    @IBOutlet weak private var postViewCell: PostView!
    
    func config(with post: RedditPost) {
        postViewCell.setup(post: post)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postViewCell.prepareForReuse()
    }

}
