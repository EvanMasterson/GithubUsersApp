//
//  SearchService.swift
//  GithubUsers
//
//  Created by Evan Masterson on 21/09/2020.
//

import Foundation

enum Urls: String {
  case searchUrl = "https://api.github.com/search/users?q=%@"
  case followersUrl = "https://api.github.com/users/%@/followers?per_page=100"
  case followingUrl = "https://api.github.com/users/%@/following?per_page=100"
  case reposUrl = "https://api.github.com/users/%@/repos?per_page=100"
  case gistsUrl = "https://api.github.com/users/%@/gists?per_page=100"
}

protocol Service {
  func search(userName: String, completion: @escaping (SearchResult?, String?) -> Void )
  func retrieveCountFor(userName: String, url: Urls, completion: @escaping (Int?) -> Void )
}

class SearchService: Service {

  private let session: URLSession

  init(session: URLSession = .shared) {
    self.session = session
  }

  func search(userName: String, completion: @escaping (SearchResult?, String?) -> Void ) {
    let urlString = String.init(format: Urls.searchUrl.rawValue, userName)
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

  func retrieveCountFor(userName: String, url: Urls, completion: @escaping (Int?) -> Void ) {
    let urlString = String.init(format: url.rawValue, userName)
    var count = 0

    guard let url = URL(string: urlString) else { return completion(count) }
    let task = session.dataTask(with: url) { (data, response, error) in
      guard let data = data else { return completion(count) }
      do {
        if let result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any] {
          count = result.count
          completion(count)
        }
      } catch {
        completion(count)
      }
    }
    task.resume()
  }
}
