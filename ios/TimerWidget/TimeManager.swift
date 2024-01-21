//
//  TimeManager.swift
//  FancyTimer
//
//  Created by Raúl Gómez Acuña on 21/01/2024.
//

import Foundation

class TimeManager {
  private var startTime: Date?

  func setStartTime(_ startTime: Date) {
    self.startTime = startTime
  }

  func getTotalDurationInSeconds() -> Int {
    let initialTime: Int = 0
    guard let startTime = self.startTime else {
      return initialTime
    }

    let now = Date()
    return Int(now.timeIntervalSince1970 - startTime.timeIntervalSince1970)
  }
}
