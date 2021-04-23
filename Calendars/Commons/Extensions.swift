//
//  Extensions.swift
//  Calendars
//
//  Created by Nguyen Mau Dat on 23/04/2021.
//

import Foundation

enum Utils {
	static var monotonicClockTime: TimeInterval {
		var result: mach_timespec
		clock_get_time(CLOCK_MONOTONIC.rawValue, &result)
		return TimeInterval(result.tv_sec) + TimeInterval(result.tv_nsec) * 1e-09
	}

	static func osVersionIsAtLeast(_ version: OperatingSystemVersion) -> Bool {
		ProcessInfo.processInfo.isOperatingSystemAtLeast(version)
	}
}
