//
//  CountDownViewModel.swift
//  ChessV2
//
//  Created by Trần Ân on 12/7/24.
//

import Foundation

class CountDownViewModel: ObservableObject {
    @Published var milLeft = 60000
    @Published var timer: Timer?
    
    init(milLeft: Int = 60000) {
        self.milLeft = milLeft
    }
    
    func startTime() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.milLeft > 0 {
                self.milLeft -= 100
            } else {
                self.stopCountdown()
            }
        }
    }
    
    func getMilLeft() -> Int {
        return milLeft
    }
    
    func pauseCountdown() {
        timer?.invalidate()
    }
    
    func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }
    
    func resumeCountdown() {
        startTime()
    }
    
    func setCoundown(mil: Int) {
        self.milLeft = mil
    }
}
