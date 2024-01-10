//
//  TimerWidgetLiveActivity.swift
//  TimerWidget
//
//  Created by Raúl Gómez Acuña on 07/01/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerWidgetAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    // Dynamic stateful properties about your activity go here!
    var elapsedTimeInSeconds: Int
    
    func formattedTime() -> String {
      let minutes = (elapsedTimeInSeconds % 3600) / 60
      let seconds = elapsedTimeInSeconds % 60
      return String(format: "%02d:%02d", minutes, seconds)
    }
  }
}

struct TimerWidgetLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: TimerWidgetAttributes.self) { context in
      // Lock screen/banner UI goes here
      VStack {
        Text(context.state.formattedTime())
          .font(.title)
          .fontWeight(.medium)
      }
      .activityBackgroundTint(Color.cyan)
      .activitySystemActionForegroundColor(Color.black)
    } dynamicIsland: { context in
      DynamicIsland {
        // Expanded Region
        DynamicIslandExpandedRegion(.center) {
          Text(context.state.formattedTime())
            .font(.title)
            .foregroundColor(.cyan)
            .fontWeight(.medium)
        }
      } compactLeading: {
        Image("TimerIcon")
          .resizable()
          .frame(width: 24, height: 24)
      } compactTrailing: {
        Text(context.state.formattedTime())
          .foregroundColor(.cyan)
      } minimal: {
        Image("TimerIcon")
          .resizable()
          .frame(width: 24, height: 24)
      }
      .widgetURL(URL(string: "http://www.apple.com"))
      .keylineTint(Color.red)
    }
  }
}

extension TimerWidgetAttributes {
  fileprivate static var preview: TimerWidgetAttributes {
    TimerWidgetAttributes()
  }
}

extension TimerWidgetAttributes.ContentState {
  fileprivate static var long: TimerWidgetAttributes.ContentState {
    TimerWidgetAttributes.ContentState(elapsedTimeInSeconds: 1846)
  }
  
  fileprivate static var short: TimerWidgetAttributes.ContentState {
    TimerWidgetAttributes.ContentState(elapsedTimeInSeconds: 30)
  }
}

#Preview("Notification", as: .content, using: TimerWidgetAttributes.preview) {
  TimerWidgetLiveActivity()
} contentStates: {
  TimerWidgetAttributes.ContentState.short
  TimerWidgetAttributes.ContentState.long
}
