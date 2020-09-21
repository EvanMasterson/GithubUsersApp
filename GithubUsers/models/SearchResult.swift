//
//  SearchResult.swift
//  GithubUsers
//
//  Created by Evan Masterson on 21/09/2020.
//

import Foundation

struct SearchResult: Decodable {
  let items: [User]
}

struct User: Decodable {
  enum CodingKeys: String, CodingKey {
    case name = "login"
    case avatarUrl = "avatar_url"
  }

  let name: String
  let avatarUrl: String
}
