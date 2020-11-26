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
    #if os(iOS)
    NavigationView {
      // Known issue: the list only appears on the sidebar in landscape orientation
      TeamList(teamStore: teamStore, showingAddTeamModal: $showingAddTeamModal)
        .navigationBarTitle("MCC Predictor")
        .navigationBarItems(leading: EditButton(), trailing: Button(action: {
          showingAddTeamModal = true
        }, label: {
          Image(systemName: "plus")
            .padding() // Make the tap target larger
        })
        )
    }
    #else
    TeamList(teamStore: teamStore, showingAddTeamModal: $showingAddTeamModal)
      .toolbar {
        Button(action: {
          showingAddTeamModal = true
        }, label: {
          Image(systemName: "plus")
        })
      }
    #endif
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
    }
  }
}

struct TeamList: View {
  @ObservedObject var teamStore: TeamStore
  
  @Binding var showingAddTeamModal: Bool
  
  #if os(macOS)
  @State private var selection: Team?
  #endif
  
  var body: some View {
    #if os(iOS)
    let forEachTeam = ForEach(teamStore.teams) { team in
      TeamCellView(teamStore: teamStore, team: team)
    }
    #else
    let forEachTeam = ForEach(teamStore.teams) { team in
      TeamCellView(teamStore: teamStore, team: team)
        .background(selection == team ? Color.accentColor : nil)
        .onTapGesture {
          selection = team
        }
    }
    #endif
    
    #if os(iOS)
    List {
      forEachTeam
        .onDelete { indexSet in
          teamStore.teams.remove(atOffsets: indexSet)
        }
    }
    .listStyle(InsetListStyle())
    .sheet(isPresented: $showingAddTeamModal) {
      NavigationView { NewTeamView(teamStore: teamStore) }
    }
    
    #else
    List(selection: $selection) {
      forEachTeam
        .sheet(isPresented: $showingAddTeamModal) {
          NewTeamView(teamStore: teamStore)
        }
    }
    .onDeleteCommand {
      if let selection = selection, let index = teamStore.teams.firstIndex(of: selection) {
        teamStore.teams.remove(at: index)
      }
    }
    #endif
  }
}
