//
//  SearchService.swift
//  GithubUsers
//
//  Created by Evan Masterson on 21/09/2020.
//

import Foundation

class SearchService {
  let baseUrl: String = "https://api.github.com/search/users?q="

  func search(userName: String, completion: @escaping (SearchResult?, ServiceError?) -> Void ) {
    var urlString = baseUrl + userName
    urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

    if let url = URL(string: urlString) {
      let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else { return }
        do {
          let result = try JSONDecoder().decode(SearchResult.self, from: data)
          return completion(result, nil)
        } catch {
          return completion(nil, ServiceError.runtimeError("Something went wrong!"))
        }
      }
      task.resume()
    }
  }
}

enum ServiceError: Error {
  case runtimeError(String)
}
