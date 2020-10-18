//
//  ContentView.swift
//  MCCPredictions
//
//  Created by Kenneth Chew on 10/18/20.
//

import SwiftUI

struct ContentView: View {
  /// The mean of the average score of the 4 players in the team.
  @State private var averageScore = "0.0"
  /// The mean of the average wins of the 4 players in the team.
  @State private var averageWins = "0.0"
  /// The mean of the average times each player was placed in the top 10 of the 4 players in the team.
  @State private var averageTopTen = "0.0"
  
  @State private var alertTitle = "Prediction"
  @State private var alertMessage = ""
  @State private var showingAlert = false
  
  var body: some View {
    Form {
      Section(header: Text("Average Score")) {
        TextField("Average Score", text: $averageScore)
          .keyboardType(.decimalPad)
        
      }
      
      Section(header: Text("Average Wins")) {
        TextField("Average Wins", text: $averageWins)
          .keyboardType(.decimalPad)
      }
      
      Section(header: Text("Average Top Ten")) {
        TextField("Average Top Ten", text: $averageTopTen)
          .keyboardType(.decimalPad)
      }
      
      Button("Calculate") {
        predictPlacement(averageScores: Double(averageScore) ?? 0.0, averageWins: Double(averageWins) ?? 0.0, averageTop10: Double(averageTopTen) ?? 0.0)
      }
      .alert(isPresented: $showingAlert) {
        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
      }
    }
  }
  
  func predictPlacement(averageScores: Double, averageWins: Double, averageTop10: Double) {
    Predictor.load { model in
      do {
        let prediction = try model.get().prediction(Team_Average_Scores: averageScores, Team_Average_Wins: averageWins, Team_Average_Top_10: averageTop10)
        alertTitle = "Prediction"
        alertMessage = "Predicted placement: \(prediction.Position)"
      } catch {
        alertTitle = "Error"
        alertMessage = "Failed to create prediction"
      }
      showingAlert = true
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
