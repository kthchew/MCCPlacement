//
//  ContentView.swift
//  MCCPredictions
//
//  Created by Kenneth Chew on 10/18/20.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var teamStore = TeamStore()
  
  @State private var showingAddTeamModal = false
  
  var body: some View {
    NavigationView {
      // Known issue: the list only appears on the sidebar in landscape orientation
      List {
        ForEach(teamStore.teams) { team in
          TeamCellView(teamStore: teamStore, team: team)
        }
        .onDelete { indexSet in
          teamStore.teams.remove(atOffsets: indexSet)
        }
      }
      .listStyle(InsetListStyle())
      .navigationBarTitle("MCC Predictor")
      .navigationBarItems(leading: EditButton(), trailing: Button(action: {
        showingAddTeamModal = true
      }, label: {
        Image(systemName: "plus")
          .frame(width: 16, height: 16) // Make the tap target larger
      })
      .contentShape(Rectangle())
      )
      .sheet(isPresented: $showingAddTeamModal) {
        NavigationView { NewTeamView(teamStore: teamStore) }
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct TeamCellView: View {
  @ObservedObject var teamStore: TeamStore
  let team: Team
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(team.name)
          .font(.headline)
        
        Group {
          Text("Average Score: \(team.averageScore, specifier: "%.2f")")
          Text("Average Wins: \(team.averageWins, specifier: "%.2f")")
          Text("Average Top 10: \(team.averageTopTen, specifier: "%.2f")")
        }
        .font(.caption)
      }
      
      Spacer()
      
      Text("#\((teamStore.teams.firstIndex(of: team) ?? -1) + 1)")
        .padding()
    }
  }
}
