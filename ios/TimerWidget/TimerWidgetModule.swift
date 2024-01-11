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

  private func areActivitiesEnabled() -> Bool {
    return ActivityAuthorizationInfo().areActivitiesEnabled
  }

  @objc
  func startLiveActivity() -> Void {
    if (!areActivitiesEnabled()) {
      // User disabled Live Activities for the app, nothing to do
      return
    }

    // Preparing data for the Live Activity
    let activityAttributes = TimerWidgetAttributes()
    // This will be dynamic later ;)
    let contentState = TimerWidgetAttributes.ContentState(elapsedTimeInSeconds: 0)
    let activityContent = ActivityContent(state: contentState,  staleDate: nil)

    do {
      // Request to start a new Live Activity with the content defined above
      try Activity.request(attributes: activityAttributes, content: activityContent)
    } catch {
      // Handle errors, skipped for simplicity
    }
  }

  @objc
  func stopLiveActivity() -> Void {
    // A task is a unit of work that can run concurrently in a lightweight thread, managed by the Swift runtime
    // It helps to avoid blocking the main thread
    Task {
      for activity in Activity<TimerWidgetAttributes>.activities {
        await activity.end(nil, dismissalPolicy: .immediate)
      }
    }
  }
}
