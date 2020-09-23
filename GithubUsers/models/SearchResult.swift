//
//  SearchResult.swift
//  GithubUsers
//
//  Created by Evan Masterson on 21/09/2020.
//

import Foundation

struct SearchResult: Decodable {
  enum CodingKeys: String, CodingKey {
    case items
    case errorMessage = "message"
  }
  
  let items: [User]?
  let errorMessage: String?
}

class User: Decodable {
  enum CodingKeys: String, CodingKey {
    case name = "login"
    case avatarUrl = "avatar_url"
  }

  let name: String
  let avatarUrl: String
  var followersCount: Int = 0
  var followingCount: Int = 0
  var reposCount: Int = 0
  var gistsCount: Int = 0

  func fetchCounts(completion: @escaping () -> Void) {
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    SearchService().retrieveCountFor(userName: name, url: .followersUrl) { [weak self] (count) in
      self?.followersCount = count!
      dispatchGroup.leave()
    }
    dispatchGroup.enter()
    SearchService().retrieveCountFor(userName: name, url: .followingUrl) { [weak self] (count) in
      self?.followingCount = count!
      dispatchGroup.leave()
    }
    dispatchGroup.enter()
    SearchService().retrieveCountFor(userName: name, url: .reposUrl) { [weak self] (count) in
      self?.reposCount = count!
      dispatchGroup.leave()
    }
    dispatchGroup.enter()
    SearchService().retrieveCountFor(userName: name, url: .gistsUrl) { [weak self] (count) in
      self?.gistsCount = count!
      dispatchGroup.leave()
    }
    dispatchGroup.notify(queue: .main) {
      completion()
    }
  }
}
