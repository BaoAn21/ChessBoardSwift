//
//  ContentView.swift
//  ChessV2
//
//  Created by Trần Ân on 3/7/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var chessBoardController = ChessBoardController(fen: "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
    var body: some View {
        ChessBoardView(chessBoardController: chessBoardController)
    }
}

#Preview {
    ContentView()
}
