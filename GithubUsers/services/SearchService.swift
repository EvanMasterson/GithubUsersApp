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


class SearchService {

  func search(userName: String, completion: @escaping (SearchResult?, String?) -> Void ) {
    let urlString = String.init(format: Urls.searchUrl.rawValue, userName)

    guard let url = URL(string: urlString) else { return completion(nil, "Something went wrong!") }
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else { return }
      do {
        let result = try JSONDecoder().decode(SearchResult.self, from: data)
        if result.items != nil && result.items!.count > 0 {
          return completion(result, nil)
        } else {
          return completion(nil, result.errorMessage ?? "No results found")
        }
      } catch {
        return completion(nil, "Something went wrong!")
      }
    }
    task.resume()
  }

  func retrieveCountFor(userName: String, url: Urls, completion: @escaping (Int?) -> Void ) {
    let urlString = String.init(format: url.rawValue, userName)

    guard let url = URL(string: urlString) else { return }
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else { return }
      do {
        if let result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any] {
          return completion(result.count)
        }
      } catch {
        return
      }
    }
    task.resume()
  }
}
