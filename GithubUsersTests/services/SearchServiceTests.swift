//
//  SearchServiceTests.swift
//  GithubUsersTests
//
//  Created by Evan Masterson on 23/09/2020.
//

import XCTest
@testable import GithubUsers

class SearchServiceTests: XCTestCase {

  private var searchService: SearchService?
  private var mockSession: URLSessionMock?

  override func setUpWithError() throws {
    mockSession = URLSessionMock()
    searchService = SearchService(session: mockSession!)
  }

  override func tearDownWithError() throws {
    mockSession = nil
    searchService = nil
  }

  func testGivenValidJsonResponseWhenSearchingThenResultShouldExist() throws {
    let mockData = try loadMockData(filename: "searchResultSuccess")
    let mockResult: SearchResult = try JSONDecoder().decode(SearchResult.self, from: mockData)
    mockSession?.data = mockData

    searchService?.search(userName: "name", completion: { (result, error) in
      XCTAssertEqual(result?.items?.first?.name, mockResult.items?.first?.name)
      XCTAssertNotNil(result)
      XCTAssertNil(error)
    })
  }

  func testGivenErrorJsonResponseWhenSearchingThenErrorMessageShouldExist() throws {
    mockSession?.data = try loadMockData(filename: "searchResultError")

    searchService?.search(userName: "name", completion: { (result, error) in
      XCTAssertNil(result)
      XCTAssertEqual(error, "API rate limit exceeded for 212.187.194.213. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)")
    })
  }

  func testGivenInvalidDataWhenSearchingThenResultShouldNotExist() throws {
    mockSession?.data = Data(bytes: [0, 0, 0, 0], count: 0)

    searchService?.search(userName: "name", completion: { (result, error) in
      XCTAssertNil(result)
      XCTAssertEqual(error, "Something went wrong!")
    })
  }

  func testGivenNilDataWhenSearchingThenResultShouldNotExist() throws {
    mockSession?.data = nil

    searchService?.search(userName: "name", completion: { (result, error) in
      XCTAssertNil(result)
      XCTAssertEqual(error, "Something went wrong!")
    })
  }

  func testGivenValidDataWhenRetrievingCountsThenCountShouldNotBeZero() throws {
    mockSession?.data = try loadMockData(filename: "followersResult")

    searchService?.retrieveCountFor(userName: "name", urlType: .followersUrl, completion: { (count) in
      XCTAssertEqual(count, 2)
    })
  }

  func testGivenInvalidDataWhenRetrievingCountsThenCountShouldBeZero() throws {
    mockSession?.data = Data(bytes: [0, 0, 0, 0], count: 0)

    searchService?.retrieveCountFor(userName: "name", urlType: .reposUrl, completion: { (count) in
      XCTAssertEqual(count, 0)
    })
  }

  func testGivenNilDataWhenRetrievingCountsThenCountShouldBeZero() throws {
    mockSession?.data = nil

    searchService?.retrieveCountFor(userName: "name", urlType: .reposUrl, completion: { (count) in
      XCTAssertEqual(count, 0)
    })
  }

  func loadMockData(filename: String) throws -> Data {
    let path = Bundle(for: SearchResultTests.self).path(forResource: filename, ofType: "json")
    let mockData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
    return mockData
  }
}


class URLSessionMock: URLSession {
  var data: Data?
  var error: Error?

  override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    let data = self.data
    let error = self.error

    return URLSessionDataTaskMock {
      completionHandler(data, nil, error)
    }
  }
}

class URLSessionDataTaskMock: URLSessionDataTask {
  private let closure: () -> Void

  init(closure: @escaping () -> Void) {
    self.closure = closure
  }

  override func resume() {
    closure()
  }
}
