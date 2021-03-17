//
//  MCCPlacementTests.swift
//  MCCPlacementTests
//
//  Created by Kenneth Chew on 10/18/20.
//

import XCTest
@testable import MCCPlacement__iOS_

class MCCPlacementiOSTests: XCTestCase {
  
  let sampleTeam = Team(name: "Test", averageScore: 2000.0, averageWins: 0.3, averageTopTen: 0.25)
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testTeamJSONRepresentation() throws {
    let encoder = JSONEncoder()
    guard let encodedData = try? encoder.encode(sampleTeam) else {
      XCTFail("Failed to encode the data.")
      return
    }
    
    let decoder = JSONDecoder()
    guard let decodedData = try? decoder.decode(Team.self, from: encodedData) else {
      XCTFail("Failed to decode the data.")
      return
    }
    
    XCTAssertEqual(sampleTeam, decodedData)
  }
  
}
