//
//  APICaller.swift
//  NewsAppSimple
//
//  Created by justSmK on 04.04.2022.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    
    
    struct Constants {
        static let apiKey: String = "82aa389a059940919b245cdab524163a"
        
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)")
        
        static let searchUrlString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=\(apiKey)&q="
    }
    
    private init() {
        
    }
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    public func search(with querry: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !querry.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = Constants.searchUrlString + querry
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

//Models

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
//    let author: String
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
//    let content: String
}

struct Source: Codable {
    let name: String
}
