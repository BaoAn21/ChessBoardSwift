//
//  CountDownClock.swift
//  ChessV2
//
//  Created by Trần Ân on 12/7/24.
//

import SwiftUI

struct CountDownClock: View {
    @ObservedObject var countDownViewModel = CountDownViewModel(milLeft: 400000)
    
    
    var body: some View {
        VStack {
            TimerView(mil: countDownViewModel.milLeft)
        }
        .onDisappear {
            countDownViewModel.stopCountdown()
        }
    }
    
    struct TimerView: View {
        static func millisecondsToMinutes1(milliseconds: Int) -> Int {
            return milliseconds / 60000
        }
        
        static func millisecondsToSecond(mil : Int) -> Int {
            return mil / 1000
        }
        static func convertMilToNormalTime(mil: Int) -> (Int,Int,Int) {
            var formatTime = (0,0,0)
            let getMinutes = millisecondsToMinutes1(milliseconds: mil)
            formatTime.0 = getMinutes
            let milLeft = mil - getMinutes*60000
            let getSeconds = millisecondsToSecond(mil: milLeft)
            let lastMilLeft = milLeft - getSeconds*1000
            formatTime.1 = getSeconds
            let mil = lastMilLeft / 100
            formatTime.2 = mil
            return formatTime
        }
        let mil: Int
        var formatTime: (Int,Int,Int)
        init(mil: Int) {
            self.mil = mil
            formatTime = CountDownClock.TimerView.convertMilToNormalTime(mil: mil)
        }
        var body: some View {
            HStack(spacing: 0) {
                Text("\(formatTime.0):")
                Text("\(formatTime.1).")
                Text("\(formatTime.2)")
            }
            .font(.largeTitle)
        }
    }
    
}

#Preview {
    CountDownClock()
}
