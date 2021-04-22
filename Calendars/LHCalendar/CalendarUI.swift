//
//  CalendarUI.swift
//  Calendars
//
//  Created by Nguyen Mau Dat on 19/11/2020.
//

import AppKit
import Cocoa
import Foundation
import SnapKit

class CalendarUI: NSView {
  
}

class BaseView: NSView {
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  internal func commonInit() {
    
  }
}
