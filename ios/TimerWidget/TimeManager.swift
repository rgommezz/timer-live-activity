//
//  TimeManager.swift
//  FancyTimer
//
//  Created by Raúl Gómez Acuña on 21/01/2024.
//

import Foundation

let LIVE_ACTIVITY_UPDATE_DELAY_IN_SECONDS = 0.5

class TimeManager {
  private var startTime: Date?
  private var pauseTime: Date?

  func setStartTime(_ startTime: Date) {
    self.startTime = startTime
  }
  
  func setPauseTime(_ pauseTime: Date) {
    self.pauseTime = pauseTime
  }

  func getTotalDurationInSeconds() -> Int {
    let initialTime: Int = 0
    let now = Date()
    guard let startTime = self.startTime else {
      return initialTime
    }
    guard let pauseTime = self.pauseTime else {
      // Live activity update is not immediate. Empirically it seems to be ~0.5s since calling activity.update()
      return Int(now.timeIntervalSince1970 - startTime.timeIntervalSince1970 + LIVE_ACTIVITY_UPDATE_DELAY_IN_SECONDS)
    }
    return Int(pauseTime.timeIntervalSince1970 - startTime.timeIntervalSince1970)
  }
  
  func resume() -> Void {
    guard let startTime = self.startTime else { return }
    guard let pauseTime = self.pauseTime else { return }
    let elapsedSincePaused = Date().timeIntervalSince1970 - pauseTime.timeIntervalSince1970
    self.startTime = Date(timeIntervalSince1970: startTime.timeIntervalSince1970 + elapsedSincePaused)
    self.pauseTime = nil
  }
  
  func reset() -> Void {
    self.startTime = nil
    self.pauseTime = nil
  }
}
