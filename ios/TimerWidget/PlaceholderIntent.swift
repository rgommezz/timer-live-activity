//
//  TimerWidgetLiveActivityIntent.swift
//  FancyTimer
//
//  Created by Raúl Gómez Acuña on 25/01/2024.
//

import Foundation
import AppIntents

/// To send events from here to JS and make the compiler happy, we should implement the same struct that conforms to the LiveActivityIntent protocol in separate files, one for the Widget Extension and one for the main app. This one provides
/// the real implementation for the `perform` function to send an event to JS via RCTEventEmitter
public struct PauseIntent: LiveActivityIntent {
  public init() {}
  
  public static var title: LocalizedStringResource = "Pause timer"
  static var description = IntentDescription("Pause timer")
  
  public func perform() async throws -> some IntentResult {
    return .result()
  }
}

public struct ResumeIntent: LiveActivityIntent {
  
  public init() {}
  
  public static var title: LocalizedStringResource = "Resume timer"
  static var description = IntentDescription("Resume timer")
  
  public func perform() async throws -> some IntentResult {
    return .result()
  }
}

public struct ResetIntent: LiveActivityIntent {
  
  public init() {}
  
  public static var title: LocalizedStringResource = "Reset timer"
  static var description = IntentDescription("Reset timer")
  
  public func perform() async throws -> some IntentResult {
    return .result()
  }
}
