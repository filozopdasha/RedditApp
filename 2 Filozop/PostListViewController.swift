//
//  PostListViewController.swift
//  2 Filozop
//
//  Created by Dasha Filozop on 18.03.2025.
//

import Foundation
import UIKit

class PostListViewController: UITableViewController {
    
    struct Const {
        static let postDetailsIdentifier = "post_details"
    }
    
    @IBOutlet weak private var Subreddit: UILabel!
    
    private var lastSelectedPost: RedditPost?

    var randomBool: Bool = false
    let subreddit = "ios"
    var posts: [RedditPost] = []
    private var after: String?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Subreddit.text = subreddit
                    
        Task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard !randomBool else {return}
        randomBool = true
        let postInfo = await getPostInfo(subreddit: subreddit, limit: 5, after: after)
        
        guard let newPosts = postInfo.0 else { return }
        
        DispatchQueue.main.async {
            self.posts.append(contentsOf: newPosts)
            self.after = postInfo.1
            self.tableView.reloadData()
        }
        randomBool = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PostTableViewCell",
            for: indexPath
        ) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        cell.config(with: post)
        
        return cell
    }
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == Const.postDetailsIdentifier {
            guard let nextVc = segue.destination as? PostDetailsViewController else { return }
            if let post = self.lastSelectedPost {
                nextVc.config(with: post)
            }
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        self.lastSelectedPost = self.posts[indexPath.row]
        self.performSegue(
            withIdentifier: Const.postDetailsIdentifier,
            sender: nil
        )
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard self.after != nil else { return }
            let scrollPosition = scrollView.contentOffset.y
            let screenHeight = scrollView.frame.height
            let contentHeight = scrollView.contentSize.height - 1500
            let bottom = scrollPosition + screenHeight
            
            if bottom >= contentHeight {
                Task {
                    await loadData()
                }
            }
        }
}
