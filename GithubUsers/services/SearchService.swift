//
//  SearchService.swift
//  GithubUsers
//
//  Created by Evan Masterson on 21/09/2020.
//

import Foundation

enum Urls: String {
  case searchUrl = "https://api.github.com/search/users?q=%@&page=%d&per_page=100"
  case followersUrl = "https://api.github.com/users/%@/followers?page=%d&per_page=100"
  case followingUrl = "https://api.github.com/users/%@/following?page=%d&per_page=100"
  case reposUrl = "https://api.github.com/users/%@/repos?page=%d&per_page=100"
  case gistsUrl = "https://api.github.com/users/%@/gists?page=%d&per_page=100"
}

protocol Service {
  func search(userName: String, page: Int, completion: @escaping (SearchResult?, String?) -> Void )
  func retrieveCountFor(userName: String, urlType: Urls, page: Int, existingCount: Int, completion: @escaping (Int?) -> Void )
}

class SearchService: Service {

  private let session: URLSession

  init(session: URLSession = .shared) {
    self.session = session
  }

  func search(userName: String, page: Int = 1, completion: @escaping (SearchResult?, String?) -> Void ) {
    let urlString = String.init(format: Urls.searchUrl.rawValue, userName, page)
    let errorMessage = "Something went wrong!"

    guard let url = URL(string: urlString) else { return completion(nil, errorMessage) }
    let task = session.dataTask(with: url) { (data, response, error) in
      guard let data = data else { return completion(nil, errorMessage) }
      do {
        let result = try JSONDecoder().decode(SearchResult.self, from: data)
        if result.items != nil && result.items!.count > 0 {
          completion(result, nil)
        } else {
          completion(nil, result.errorMessage ?? "No results found")
        }
      } catch {
        completion(nil, errorMessage)
      }
    }
    task.resume()
  }

  func retrieveCountFor(userName: String, urlType: Urls, page: Int = 1, existingCount: Int = 0, completion: @escaping (Int?) -> Void ) {
    let urlString = String.init(format: urlType.rawValue, userName, page)
    var count = existingCount

    guard let url = URL(string: urlString) else { return completion(count) }
    let task = session.dataTask(with: url) { (data, response, error) in
      guard let data = data else { return completion(count) }
      do {
        if let result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any] {
          count += result.count
          if count != 0 && count % 100 == 0 {
            let pageCount = page + 1
            return self.retrieveCountFor(userName: userName, urlType: urlType, page: pageCount, existingCount: count, completion: completion)
          }
          completion(count)
        }
      } catch {
        completion(count)
      }
    }
    task.resume()
  }
}
