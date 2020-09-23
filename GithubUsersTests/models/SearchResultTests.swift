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
    try loadJson(filename: "searchResultSuccess")
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
    try loadJson(filename: "searchResultError")

    let user = searchResult?.items?.first
    XCTAssertNil(user?.name)
    XCTAssertNil(user?.avatarUrl)
  }

  func testGivenSuccessfulJsonResponseWhenInitialisingThenErrorMessageShouldExist() throws {
    try loadJson(filename: "searchResultError")
    
    let doesMessageContainText = searchResult!.errorMessage!.contains("API rate limit exceeded")
    XCTAssertNotNil(searchResult?.errorMessage)
    XCTAssertTrue(doesMessageContainText)
  }

  func testGivenValidDataWhenFetchingCountsThenUserModelObjectsShouldBeCorrect() throws {
    let mockSession = URLSessionMock()
    let searchService = SearchService(session: mockSession)
    let path = Bundle(for: SearchServiceTests.self).path(forResource: "followersResult", ofType: "json")
    let mockData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
    mockSession.data = mockData

    let user = searchResult?.items?.first
    user?.fetchCounts(searchService: searchService, completion: {
      XCTAssertEqual(user?.followersCount, 2)
      XCTAssertEqual(user?.followingCount, 2)
      XCTAssertEqual(user?.reposCount, 2)
      XCTAssertEqual(user?.gistsCount, 2)
    })
  }

  func loadJson(filename: String) throws {
    let path = Bundle(for: SearchResultTests.self).path(forResource: filename, ofType: "json")
    let mockData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
    searchResult = try JSONDecoder().decode(SearchResult.self, from: mockData)
  }

}
