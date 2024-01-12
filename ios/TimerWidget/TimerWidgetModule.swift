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
  private var elapsedTime: TimeInterval = 0
  private var timer: Timer?
  private var currentActivity: Activity<TimerWidgetAttributes>?
  
  private func areActivitiesEnabled() -> Bool {
    return ActivityAuthorizationInfo().areActivitiesEnabled
  }
  
  private func startTimer() {
    DispatchQueue.main.async {
      self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
        guard let strongSelf = self else { return }
        strongSelf.elapsedTime += 1
        // Update Live Activity with new elapsedTime
        let contentState = TimerWidgetAttributes.ContentState(elapsedTimeInSeconds: Int(strongSelf.elapsedTime))
        Task {
          await strongSelf.currentActivity?.update(
            ActivityContent<TimerWidgetAttributes.ContentState>(
              state: contentState,
              staleDate: nil
            )
          )
        }
      }
    }
  }
  
  private func resetValues() {
    timer?.invalidate()
    timer = nil
    elapsedTime = 0
    currentActivity = nil
  }
  
  @objc
  func startLiveActivity() -> Void {
    if (!areActivitiesEnabled()) {
      // User disabled Live Activities for the app, nothing to do
      return
    }
    
    // Preparing data for the Live Activity
    let activityAttributes = TimerWidgetAttributes()
    let contentState = TimerWidgetAttributes.ContentState(elapsedTimeInSeconds: 0)
    let activityContent = ActivityContent(state: contentState,  staleDate: nil)
    
    do {
      // Request to start a new Live Activity with the content defined above
      currentActivity = try Activity.request(attributes: activityAttributes, content: activityContent)
      startTimer()
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
}
