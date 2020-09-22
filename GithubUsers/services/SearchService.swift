//
//  SearchService.swift
//  GithubUsers
//
//  Created by Evan Masterson on 21/09/2020.
//

import Foundation

class SearchService {
  let baseUrl: String = "https://api.github.com/search/users?q="

  func search(userName: String, completion: @escaping (SearchResult?, String?) -> Void ) {
    var urlString = baseUrl + userName
    urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

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
  
}
