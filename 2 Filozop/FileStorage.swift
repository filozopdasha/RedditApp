//
//  FileStorage.swift
//  2 Filozop
//
//  Created by Dasha Filozop on 25.03.2025.
//

import Foundation

final class FileStorage {
    
    static let shared = FileStorage()
    private let filePath: URL
 
    private init() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        filePath = documentsURL.appendingPathComponent("posts.json")
        print(filePath)
    }
    
    func save(postList posts: [RedditPost]) {
        do {
            let json = try JSONEncoder().encode(posts)
            try json.write(to: filePath)
        } catch {
            print("Error")
        }
    }
    
    func fetchPosts() -> [RedditPost]? {
        guard let data = try? Data(contentsOf: filePath) else {
            return nil
        }
        
        do {
            let loadedPosts = try JSONDecoder().decode([RedditPost].self, from: data)
            return loadedPosts
        } catch {
            return nil
        }
    }

    
}
