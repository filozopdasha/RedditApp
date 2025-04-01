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
    
    
    @IBOutlet weak private var postView: PostView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let redditPost else { return }
        postView.setup(post: redditPost)
    }
    
    func config(with post: RedditPost) {
        self.redditPost = post
    }
    
}
