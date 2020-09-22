//
//  SearchResultTests.swift
//  GithubUsersTests
//
//  Created by Evan Masterson on 22/09/2020.
//

import XCTest
@testable import GithubUsers

class SearchResultTests: XCTestCase {

  private var searchResult: SearchResult?

  override func setUpWithError() throws {
    try super.setUpWithError()
    try loadJsonFile(filename: "searchResultSuccess")
  }

  override func tearDownWithError() throws {
    searchResult = nil
    try super.tearDownWithError()
  }

  func testGivenSuccessfulJsonResponseWhenInitialisingThenUserObjectsShouldExist() throws {
    let user = searchResult?.items?.first
    XCTAssertEqual(user?.name, "EvanMasterson")
    XCTAssertEqual(user?.avatarUrl, "https://avatars2.githubusercontent.com/u/8803875?v=4")
  }

  func testGivenSuccessfulJsonResponseWhenInitialisingThenErrorMessageShouldNotExist() throws {
    XCTAssertNil(searchResult?.errorMessage)
  }

  func testGivenErrorJsonResponseWhenInitialisingThenUserObjectsShouldNotExist() throws {
    try loadJsonFile(filename: "searchResultError")

    let user = searchResult?.items?.first
    XCTAssertNil(user?.name)
    XCTAssertNil(user?.avatarUrl)
  }

  func testGivenSuccessfulJsonResponseWhenInitialisingThenErrorMessageShouldExist() throws {
    try loadJsonFile(filename: "searchResultError")
    
    let doesMessageContainText = searchResult!.errorMessage!.contains("API rate limit exceeded")
    XCTAssertNotNil(searchResult?.errorMessage)
    XCTAssertTrue(doesMessageContainText)
  }

  func loadJsonFile(filename: String) throws {
    let path = Bundle(for: SearchResultTests.self).path(forResource: filename, ofType: "json")
    let mockJsonData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
    searchResult = try JSONDecoder().decode(SearchResult.self, from: mockJsonData)
  }

}
