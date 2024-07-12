//
//  MainScreen.swift
//  ChessV2
//
//  Created by Trần Ân on 10/7/24.
//

import SwiftUI

struct MainScreen: View {
    @State private var navigateToScreenB = false
    @State private var boardId: String?
    let api = "lip_IWZ4ELQzWdJgDsjQOrOS"
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    ChallengeAPI.challengeMaiaBot(tokenId: api)
                    isLoading = true
                }, label: {
                    Text("Challenge Maia1 Bot")
                })
                if isLoading {
                    Text("finding a game")
                }
            }
            .navigationTitle("Menu")
            .onAppear {
                EventAPI.streamEvent(tokenId: api) { gameStartEvent in
                    self.boardId = gameStartEvent.game.gameId
                    isLoading = false
                    self.navigateToScreenB = true
                }
            }
            .navigationDestination(isPresented: $navigateToScreenB) {
                if let boardID = boardId {
                    ChessPlayView(api: api, boardID: boardID, navigationComeback: $navigateToScreenB)
                }
            }
            .onDisappear(perform: {
                print("switch")
            })
        }
    }
}

#Preview {
    MainScreen()
}
