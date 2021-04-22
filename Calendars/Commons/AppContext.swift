//
//  AppContext.swift
//  Calendars
//
//  Created by Nguyen Mau Dat on 19/11/2020.
//

import Foundation

class AppContext {
  static func initializeApplication() {
    // Get the default firstWeekday for user's locale.
    // User can change this in preferences.
    let cal = NSCalendar.autoupdatingCurrent
    let weekStartDOW = min(max(cal.firstWeekday - 1, 0), 6)
    UserDefaults.standard.register(defaults: [
      Constants.DefaultKeys.pinCalendar: false,
      Constants.DefaultKeys.showWeeks: false,
      Constants.DefaultKeys.highlightedDOWs: 0,
      Constants.DefaultKeys.showEventDays: 7,
      Constants.DefaultKeys.weekStartDOW: weekStartDOW,
      Constants.DefaultKeys.showMonthInIcon: false,
      Constants.DefaultKeys.showDayOfWeekInIcon: false,
      Constants.DefaultKeys.showEventDots: true,
      Constants.DefaultKeys.useColoredDots: true,
      Constants.DefaultKeys.themePreference: Preference.Theme.system,
      Constants.DefaultKeys.themeSize: Preference.Sizer.default,
      Constants.DefaultKeys.hideIcon: false
    ])

    let validDays = min(max(UserDefaults.standard.integer(forKey: Constants.DefaultKeys.showEventDays), 0), 9)
    UserDefaults.standard.set(validDays, forKey: Constants.DefaultKeys.showEventDays)

    // Set kThemePreference to defaultThemePref in the unlikely case it's invalid.
    let themePref = UserDefaults.standard.object(forKey: Constants.DefaultKeys.themePreference) as? Preference.Theme ?? .system
    UserDefaults.standard.set(themePref, forKey: Constants.DefaultKeys.themePreference)

    let themeSize = UserDefaults.standard.object(forKey: Constants.DefaultKeys.themeSize) as? Preference.Sizer ?? .default
    UserDefaults.standard.set(themeSize, forKey: Constants.DefaultKeys.themeSize)

    UserDefaults.standard.synchronize()
  }
}
