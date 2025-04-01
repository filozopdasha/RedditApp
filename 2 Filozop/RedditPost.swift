//
//  RedditPost.swift
//  2 Filozop
//
//  Created by Dasha Filozop on 10.03.2025.
//


import Foundation

class RedditPost: Codable {
    let title: String
    let author_fullname: String
    let domain: String
    let num_comments: Int
    var saved: Bool
    let ups: Int
    let downs: Int
    let url_overridden_by_dest: String?
    let created: Int
    let permalink: String

    func toggleSaved() {
        saved.toggle()
    }
}

struct RedditData: Codable {
    let children: [Info]
    let after: String?
}

struct Info: Codable {
    let data: RedditPost
}

struct RedditResponse: Codable {
    let data: RedditData
}

func urlBuilder(subreddit: String, limit: Int, after: String?, another: [String: String]) -> URL? {
    var redditUrl = "https://www.reddit.com/r/\(subreddit)/top.json?limit=\(limit)"
    if let after = after, !after.isEmpty {
        redditUrl += "&after=\(after)"
    }
    print(redditUrl)
    var parameters: [String] = []
    for (key, value) in another {
        parameters.append("\(key)=\(value)")
    }
    let params = parameters.joined(separator: "&")
    if !params.isEmpty {
        redditUrl += "&" + params
    }
    let url  = URL(string: redditUrl)
    return url
}

func getPostInfo(subreddit: String, limit: Int, after: String?, another: [String: String] = [:]) async -> ([RedditPost]?, String?) {
    guard let url = urlBuilder(subreddit: subreddit, limit: limit, after: after ?? "", another: another) else {
        print("Error")
        return (nil, "")
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(RedditResponse.self, from: data)
        let downloadedPosts = response.data.children.map { $0.data }
        print(after ?? "nil")
        print(response.data.after ?? "nil")
        return (downloadedPosts, response.data.after)
    } catch {
        print("Error decoding JSON:", error)
        return (nil, "")
    }
}






