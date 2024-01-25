//
//  TimerEventEmitter.swift
//  FancyTimer
//
//  Created by Raúl Gómez Acuña on 25/01/2024.
//

import Foundation

@objc(TimerEventEmitter)
class TimerEventEmitter: RCTEventEmitter {
  
  public static var emitter: TimerEventEmitter?
  
  override init() {
    super.init()
    TimerEventEmitter.emitter = self
  }
  
  override func supportedEvents() -> [String]! {
    return ["onPause", "onResume", "onReset"]
  }
}

