//
//  NewTeamView.swift
//  MCCPlacement
//
//  Created by Kenneth Chew on 10/18/20.
//

import SwiftUI

struct NewTeamView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @State private var name = ""
  @State private var averageScore = ""
  @State private var averageWins = ""
  @State private var averageTopTen = ""
  
  @State private var showingErrorAlert = false
  
  @ObservedObject var teamStore: TeamStore
  
  var body: some View {
    
    let addButton: Button<Text> = Button("Add") {
      guard let averageScore = Double(averageScore), let averageWins = Double(averageWins), let averageTopTen = Double(averageTopTen) else {
        // Show the user an error if they enter something other than a floating point number
        showingErrorAlert = true
        return
      }
      
      teamStore.teams.append(Team(name: name, averageScore: averageScore, averageWins: averageWins, averageTopTen: averageTopTen))
      // Automatically put the list of teams in order from best position to worst
      teamStore.teams.sort { (teamOne, teamTwo) in
        teamOne.predictedPlacement < teamTwo.predictedPlacement
      }
      
      presentationMode.wrappedValue.dismiss()
    }
    
    Form {
      Section(header: Text("Team Name")) {
        TextField("Name", text: $name)
          .autocapitalization(.words)
      }
      
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
      .alert(isPresented: $showingErrorAlert) {
        Alert(title: Text("Error"), message: Text("Please fill all statistics with numbers."), dismissButton: .default(Text("OK")))
      }
    }
    .navigationBarTitle("Add new team", displayMode: .inline)
    .navigationBarItems(leading:
                          Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                          }, trailing:
                            addButton
    )
  }
}

struct NewTeamView_Previews: PreviewProvider {
  static var previews: some View {
    NewTeamView(teamStore: TeamStore())
  }
}
