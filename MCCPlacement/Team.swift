//
//  Team.swift
//  MCCPlacement
//
//  Created by Kenneth Chew on 10/18/20.
//

import Foundation
import CoreML

/// A Minecraft Championships team with associated statistics.
struct Team: Codable, Hashable, Identifiable {
  let id: UUID
  /// The name of the team.
  let name: String
  /// The mean of the average score of the 4 players in the team.
  let averageScore: Double
  /// The mean of the average wins of the 4 players in the team.
  let averageWins: Double
  /// The mean of the average times each player was placed in the top 10 of the 4 players in the team.
  let averageTopTen: Double
  /// A value indicating the ML model's prediction as to how this team would place in a game. Lower is better.
  var predictedPlacement: Double {
    guard let predictor = try? Predictor(configuration: MLModelConfiguration()) else {
      return 0.0
    }
    
    guard let prediction = try? predictor.prediction(Team_Average_Scores: averageScore, Team_Average_Wins: averageWins, Team_Average_Top_10: averageTopTen) else {
      return 0.0
    }
    
    return prediction.Position
  }
  
  init(name: String, averageScore: Double, averageWins: Double, averageTopTen: Double) {
    self.id = UUID()
    self.name = name
    self.averageScore = averageScore
    self.averageWins = averageWins
    self.averageTopTen = averageTopTen
  }
}

/// A `TeamStore` stores an array of `Team`s, sorted by best position to worst position.
class TeamStore: ObservableObject {
  @Published var teams: [Team] {
    didSet {
      // Automatically save teams to disk as they are added or removed.
      let encoder = JSONEncoder()
      if let encodedData = try? encoder.encode(teams) {
        UserDefaults.standard.set(encodedData, forKey: "Teams")
      }
    }
  }
  
  init() {
    // Automatically load teams from disk if they are present.
    if let data = UserDefaults.standard.data(forKey: "Teams") {
      let decoder = JSONDecoder()
      if let decodedData = try? decoder.decode([Team].self, from: data) {
        teams = decodedData
        return
      }
    }
    
    teams = []
  }
}
