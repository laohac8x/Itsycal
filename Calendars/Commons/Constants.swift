//
//  Constants.swift
//  Calendars
//
//  Created by Nguyen Mau Dat on 19/11/2020.
//

import AppKit
import Foundation

struct Constants {
  enum DefaultKeys {
    static let pinCalendar = "PinCalendar"
    static let showEventDays = "ShowEventDays"
    static let showWeeks = "ShowWeeks"
    static let weekStartDOW = "WeekStartDOW"
    static let highlightedDOWs = "HighlightedDOWs"
    static let keyboardShortcut = "KeyboardShortcut"
    static let useOutlineIcon = "UseOutlineIcon"
    static let showMonthInIcon = "ShowMonthInIcon"
    static let showDayOfWeekInIcon = "ShowDayOfWeekInIcon"
    static let allowOutsideApplicationsFolder = "AllowOutsideApplicationsFolder"
    static let clockFormat = "ClockFormat"
    static let hideIcon = "HideIcon"
    static let showLocation = "ShowLocation"
    static let showEventDots = "kShowEventDots"
    static let useColoredDots = "UseColoredDots"
    static let themePreference = "ThemePreference"
    static let themeSize = "ThemeSize"
  }
}

extension NSNotification.Name {
  static let preferenceSizeDidChanged = NSNotification.Name("PreferenceSizeDidChanged")
}

extension Preference {
  enum Theme: Int {
    case system
    case light
    case dark
  }

  enum Sizer: Int {
    case `default`
    case large
  }
}

class Preference {
  static let shared = Preference()

  init() {
    self.theme = UserDefaults.standard.object(forKey: Constants.DefaultKeys.themePreference) as? Theme ?? .system
    self.sizer = UserDefaults.standard.object(forKey: Constants.DefaultKeys.themeSize) as? Sizer ?? .default
    adjustAppAppearanceForPreference()
  }

  func adjustAppAppearanceForPreference() {
    switch theme {
    case .system: NSApp.appearance = nil
    case .dark: NSApp.appearance = NSAppearance(named: .darkAqua)
    case .light: NSApp.appearance = NSAppearance(named: .aqua)
    }
  }

  var theme: Theme
  var sizer: Sizer { didSet { NotificationCenter.default.post(name: .preferenceSizeDidChanged, object: nil) } }

  var agendaDayTextColor: NSColor { .secondaryLabelColor }
  var agendaDividerColor: NSColor { .separatorColor }
  var agendaDOWTextColor: NSColor { monthTextColor }
  var agendaEventDateTextColor: NSColor { .secondaryLabelColor }
  var agendaEventTextColor: NSColor { monthTextColor }
  var agendaHoverColor: NSColor { highlightedDOWBackgroundColor }
  var currentMonthOutlineColor: NSColor { NSColor(white: 053, alpha: 1) }
  var currentMonthTextColor: NSColor { .labelColor }
  var DOWTextColor: NSColor { .labelColor }
  var highlightedDOWBackgroundColor: NSColor { NSColor(named: "HighlightedDOWBackgroundColor") ?? .clear }
  var highlightedDOWTextColor: NSColor { .secondaryLabelColor }
  var hoveredCellColor: NSColor { .tertiaryLabelColor }
  var mainBackgroundColor: NSColor { NSColor(named: "MainBackgroundColor") ?? .clear }
  var monthTextColor: NSColor { NSColor.labelColor }
  var noncurrentMonthTextColor: NSColor { NSColor.disabledControlTextColor }
  var resizeHandleBackgroundColor: NSColor { highlightedDOWBackgroundColor }
  var resizeHandleForegroundColor: NSColor { NSColor(named: "ResizeHandleForegroundColor") ?? .clear }
  var selectedCellColor: NSColor { currentMonthOutlineColor }
  var todayCellColor: NSColor { NSColor(named: "TodayCellColor") ?? .clear }
  var tooltipBackgroundColor: NSColor { mainBackgroundColor }
  var weekTextColor: NSColor { .secondaryLabelColor }
  var windowBorderColor: NSColor { NSColor(named: "WindowBorderColor") ?? .clear }
}

extension Preference.Sizer {
  var fontSize: CGFloat {
    switch self {
    case .default: return 11
    case .large: return 13
    }
  }

  var calendarTitleFontSize: CGFloat {
    switch self {
    case .default: return 14
    case .large: return 16
    }
  }

  var cellSize: CGFloat {
    switch self {
    case .default: return 23
    case .large: return 28
    }
  }

  var cellTextFieldVerticalSpace: CGFloat {
    switch self {
    case .default: return 2
    case .large: return 2
    }
  }

  var cellDotWidth: CGFloat {
    switch self {
    case .default: return 3
    case .large: return 4
    }
  }

  var cellRadius: CGFloat {
    switch self {
    case .default: return 2
    case .large: return 3
    }
  }

  var agendaDotWidth: CGFloat {
    switch self {
    case .default: return 6
    case .large: return 7
    }
  }

  var agendaEventLeadingMargin: CGFloat {
    switch self {
    case .default: return 15
    case .large: return 16
    }
  }
}
