//
//  TimerWidgetLiveActivity.swift
//  TimerWidget
//
//  Created by Raúl Gómez Acuña on 07/01/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

let LIVE_ACTIVITY_SYNC_DELAY = 0.5

struct TimerWidgetAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    // Dynamic stateful properties about your activity go here!
    // Unix timestamp in seconds
    var startedAt: Date?
    var pausedAt: Date?
    
    func getElapsedTimeInSeconds() -> Int {
      let now = Date()
      guard let startedAt = self.startedAt else {
        return 0
      }
      guard let pausedAt = self.pausedAt else {
        return Int(now.timeIntervalSince1970 - startedAt.timeIntervalSince1970)
      }
      return Int(pausedAt.timeIntervalSince1970 - startedAt.timeIntervalSince1970)
    }
    
    func getPausedTime() -> String {
      let elapsedTimeInSeconds = getElapsedTimeInSeconds()
      let minutes = (elapsedTimeInSeconds % 3600) / 60
      let seconds = elapsedTimeInSeconds % 60
      return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func getTimeIntervalSinceNow() -> Double {
      guard let startedAt = self.startedAt else {
        return 0
      }
      return startedAt.timeIntervalSince1970 - LIVE_ACTIVITY_SYNC_DELAY - Date().timeIntervalSince1970
    }
  }
}

struct TimerWidgetLiveActivity: Widget {
  func rgb(_ red: Double, _ green: Double, _ blue: Double) -> Color {
    return Color(red: red/255.0, green: green/255.0, blue: blue/255.0)
  }
  
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: TimerWidgetAttributes.self) { context in
      // Lock screen/banner UI goes here
      VStack {
        Text(
          Date(
            timeIntervalSinceNow: context.state.getTimeIntervalSinceNow()
          ),
          style: .timer
        )
        .font(.title)
        .fontWeight(.medium)
      }
      .activityBackgroundTint(Color.cyan)
      .activitySystemActionForegroundColor(Color.black)
    } dynamicIsland: { context in
      DynamicIsland {
        // Expanded Region
        DynamicIslandExpandedRegion(.center) {
          ZStack {
            RoundedRectangle(cornerRadius: 24).strokeBorder(rgb(148, 163, 184), lineWidth: 2)
            HStack {
              HStack(spacing: 8.0, content: {
                Button(action: {
                  // Define the action for your button here
                  print("Play button pressed!")
                }) {
                  ZStack {
                    Circle().fill(Color.orange.opacity(0.5))
                    Image(systemName: "play.fill")
                      .imageScale(.large)
                      .foregroundColor(.orange)
                  }
                }
                .buttonStyle(PlainButtonStyle()) // Removes default button styling
                .contentShape(Rectangle()) // Ensures the tap area includes the entire custom content
                Button(action: {
                  // Define the action for your button here
                  print("Play button pressed!")
                }) {
                  ZStack {
                    Circle().fill(.gray.opacity(0.5))
                    Image(systemName: "xmark")
                      .imageScale(.medium)
                      .foregroundColor(.white)
                  }
                }
                .buttonStyle(PlainButtonStyle()) // Removes default button styling
                .contentShape(Rectangle()) // Ensures the tap area includes the entire custom content
                Spacer()
              })
              if (context.state.pausedAt != nil) {
                Text(
                  context.state.getPausedTime()
                )
                .font(.title)
                .foregroundColor(.orange)
                .fontWeight(.medium)
                .monospacedDigit()
              } else {
                Text(
                  Date(
                    timeIntervalSinceNow: context.state.getTimeIntervalSinceNow()
                  ),
                  style: .timer
                )
                .font(.title)
                .foregroundColor(.orange)
                .fontWeight(.medium)
                .monospacedDigit()
                .frame(maxWidth: 64)
              }
            }
            .padding()
          }
          .padding()
        }
      } compactLeading: {
        Image(systemName: "timer")
          .imageScale(.medium)
          .foregroundColor(.orange)
      } compactTrailing: {
        if (context.state.pausedAt != nil) {
          Text(context.state.getPausedTime())
            .foregroundColor(.orange)
            .monospacedDigit()
        } else {
          Text(
            Date(
              timeIntervalSinceNow: context.state.getTimeIntervalSinceNow()
            ),
            style: .timer
          )
          .foregroundColor(.orange)
          .monospacedDigit()
          .frame(maxWidth: 32)
        }
      } minimal: {
        Image(systemName: "timer")
          .imageScale(.medium)
          .foregroundColor(.orange)
      }
      .widgetURL(URL(string: "http://www.apple.com"))
      .keylineTint(Color.red)
    }
  }
}

//extension TimerWidgetAttributes {
//  fileprivate static var preview: TimerWidgetAttributes {
//    TimerWidgetAttributes()
//  }
//}
//
//extension TimerWidgetAttributes.ContentState {
//  fileprivate static var long: TimerWidgetAttributes.ContentState {
//    TimerWidgetAttributes.ContentState(elapsedTimeInSeconds: 1846)
//  }
//
//  fileprivate static var short: TimerWidgetAttributes.ContentState {
//    TimerWidgetAttributes.ContentState(elapsedTimeInSeconds: 30)
//  }
//}
//
//#Preview("Notification", as: .content, using: TimerWidgetAttributes.preview) {
//  TimerWidgetLiveActivity()
//} contentStates: {
//  TimerWidgetAttributes.ContentState.short
//  TimerWidgetAttributes.ContentState.long
//}
