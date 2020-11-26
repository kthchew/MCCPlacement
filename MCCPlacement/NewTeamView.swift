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
    
    #if os(iOS)
    NewTeamForm(name: $name, averageScore: $averageScore, averageWins: $averageWins, averageTopTen: $averageTopTen, showingErrorAlert: $showingErrorAlert, teamStore: teamStore)
      .navigationBarTitle("Add new team", displayMode: .inline)
      .navigationBarItems(leading:
                            Button("Cancel") {
                              presentationMode.wrappedValue.dismiss()
                            }, trailing:
                              addButton
      )
    #else
    VStack {
      NewTeamForm(name: $name, averageScore: $averageScore, averageWins: $averageWins, averageTopTen: $averageTopTen, showingErrorAlert: $showingErrorAlert, teamStore: teamStore)
        .padding()
      
      HStack {
        Button("Cancel") {
          presentationMode.wrappedValue.dismiss()
        }
        
        Spacer()
        
        addButton
      }
    }
    .padding()
    
    #endif
  }
}

struct NewTeamForm: View {
  @Binding var name: String
  @Binding var averageScore: String
  @Binding var averageWins: String
  @Binding var averageTopTen: String
  
  @Binding var showingErrorAlert: Bool
  
  @ObservedObject var teamStore: TeamStore
  
  var body: some View {
    Form {
      Section(header: Text("Team Name")) {
        #if os(iOS)
        TextField("Name", text: $name)
          .autocapitalization(.words)
        #else
        TextField("Name", text: $name)
        #endif
      }
      
      Section(header: Text("Average Score")) {
        #if os(iOS)
        TextField("Average Score", text: $averageScore)
          .keyboardType(.decimalPad)
        #else
        TextField("Average Score", text: $averageScore)
        #endif
      }
      
      Section(header: Text("Average Wins")) {
        #if os(iOS)
        TextField("Average Wins", text: $averageWins)
          .keyboardType(.decimalPad)
        #else
        TextField("Average Wins", text: $averageWins)
        #endif
      }
      
      Section(header: Text("Average Top Ten")) {
        #if os(iOS)
        TextField("Average Top Ten", text: $averageTopTen)
          .keyboardType(.decimalPad)
        #else
        TextField("Average Top Ten", text: $averageTopTen)
        #endif
      }
      .alert(isPresented: $showingErrorAlert) {
        Alert(title: Text("Error"), message: Text("Please fill all statistics with numbers."), dismissButton: .default(Text("OK")))
      }
    }
  }
}

struct NewTeamView_Previews: PreviewProvider {
  static var previews: some View {
    NewTeamView(teamStore: TeamStore())
  }
}
