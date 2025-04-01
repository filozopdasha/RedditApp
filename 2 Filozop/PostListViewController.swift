//
//  PostListViewController.swift
//  2 Filozop
//
//  Created by Dasha Filozop on 18.03.2025.
//

import Foundation
import UIKit

class PostListViewController: UITableViewController, UISearchResultsUpdating {
    
    struct Const {
        static let postDetailsIdentifier = "post_details"
    }
    
    @IBOutlet weak private var GeneralSavedButton: UIBarButtonItem!
    @IBOutlet weak private var Subreddit: UILabel!
    
    private var lastSelectedPost: RedditPost?
    private var isFilteringSavedPosts = false
    private var postsArray: [RedditPost] = []
    private var selectedPostsArray: [RedditPost] = []
    
    @Published private var filteredPosts: [RedditPost] = []
    private lazy var searchController: UISearchController = {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.placeholder = "Search"
            return controller
        }()

    @IBAction func generalSaveFunc(_ sender: UIButton) {
        isFilteringSavedPosts.toggle()
        
        let imageName: String
        if isFilteringSavedPosts {
            imageName = "bookmark.fill"
        } else {
            imageName = "bookmark"
        }
        
        sender.setImage(UIImage(systemName: imageName), for: .normal)
           
           if isFilteringSavedPosts {
               postsArray = posts
               
               if let savedPosts = FileStorage.shared.fetchPosts() {
                   posts = savedPosts
               } else {
                   posts = []
               }
               
               navigationItem.searchController = searchController
           } else {
               posts = postsArray
               navigationItem.searchController = nil
           }
           
           tableView.reloadData()
    }
    
    

    var randomBool: Bool = false
    let subreddit = "ios"
    var posts: [RedditPost] = []
    private var after: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Subreddit.text = subreddit
        GeneralSavedButton.image = UIImage(systemName: "bookmark")
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
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredPosts = posts
            tableView.reloadData()
            return
        }
        
        filteredPosts = posts.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        tableView.reloadData() 
    }
    
    private func isFiltering() -> Bool {
        return navigationItem.searchController?.isActive == true &&
               !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
                return filteredPosts.count
            }
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PostTableViewCell",
            for: indexPath
        ) as! PostTableViewCell
        
        let post = isFiltering() ? filteredPosts[indexPath.row] : posts[indexPath.row]
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
        guard !isFilteringSavedPosts, let after = self.after else { return }
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
