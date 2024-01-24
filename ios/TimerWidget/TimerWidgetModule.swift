//
//  TimerWidgetModule.swift
//  FancyTimer
//
//  Created by Raúl Gómez Acuña on 10/01/2024.
//

import Foundation
import ActivityKit


@objc(TimerWidgetModule)
class TimerWidgetModule: NSObject {
  private var currentActivity: Activity<TimerWidgetAttributes>?
  private var startedAt: Date?
  private var pausedAt: Date?
  
  private func areActivitiesEnabled() -> Bool {
    return ActivityAuthorizationInfo().areActivitiesEnabled
  }
  
  private func resetValues() {
    startedAt = nil
    pausedAt = nil
    currentActivity = nil
  }
  
  @objc
  func startLiveActivity(_ timestamp: Double) -> Void {
    startedAt = Date(timeIntervalSince1970: timestamp)
    if (!areActivitiesEnabled()) {
      // User disabled Live Activities for the app, nothing to do
      return
    }
    
    // Preparing data for the Live Activity
    let activityAttributes = TimerWidgetAttributes()
    let contentState = TimerWidgetAttributes.ContentState(startedAt: startedAt, pausedAt: nil)
    let activityContent = ActivityContent(state: contentState,  staleDate: nil)
    
    do {
      // Request to start a new Live Activity with the content defined above
      currentActivity = try Activity.request(attributes: activityAttributes, content: activityContent)
    } catch {
      // Handle errors, skipped for simplicity
    }
  }
  
  @objc
  func stopLiveActivity() -> Void {
    resetValues()
    Task {
      for activity in Activity<TimerWidgetAttributes>.activities {
        await activity.end(nil, dismissalPolicy: .immediate)
      }
    }
  }
  
  @objc
  func pause(_ timestamp: Double) -> Void {
    pausedAt = Date(timeIntervalSince1970: timestamp)
    let contentState = TimerWidgetAttributes.ContentState(startedAt: startedAt, pausedAt: pausedAt)
    Task {
      await currentActivity?.update(
        ActivityContent<TimerWidgetAttributes.ContentState>(
          state: contentState,
          staleDate: nil
        )
      )
    }
  }
  
  @objc
  func resume() -> Void {
    guard let startDate = self.startedAt else { return }
    guard let pauseDate = self.pausedAt else { return }
    
    let elapsedSincePaused = Date().timeIntervalSince1970 - pauseDate.timeIntervalSince1970
    startedAt = Date(timeIntervalSince1970: startDate.timeIntervalSince1970 + elapsedSincePaused)
    pausedAt = nil
    
    let contentState = TimerWidgetAttributes.ContentState(startedAt: startedAt, pausedAt: nil)
    Task {
      await currentActivity?.update(
        ActivityContent<TimerWidgetAttributes.ContentState>(
          state: contentState,
          staleDate: nil
        )
      )
    }
  }
}
