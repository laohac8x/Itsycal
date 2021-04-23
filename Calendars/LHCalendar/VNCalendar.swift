//
//  VNCalendar.swift
//  Itsycal
//
//  Created by Nguyen Mau Dat on 19/04/2021.
//  Copyright © 2021 mowglii.com. All rights reserved.
//

import Foundation

extension Double {
	var floorINT: Int { Int(floor(self)) }
	var intValue: Int { Int(self) }
}

extension Int {
	var doubleValue: Double { Double(self) }
}

public class VNCalendar: NSObject {
	public enum Can: String {
		case giap = "Giáp"
		case at = "Ất"
		case binh = "Bính"
		case dinh = "Đinh"
		case mau = "Mậu"
		case ky = "Kỷ"
		case canh = "Canh"
		case tan = "Tân"
		case nham = "Nhâm"
		case quy = "Quý"

		static func atIndex(_ index: Int) -> Can {
			switch index {
				case 1: return .at
				case 2: return .binh
				case 3: return .dinh
				case 4: return .mau
				case 5: return .ky
				case 6: return .canh
				case 7: return .tan
				case 8: return .nham
				case 9: return .quy
				default: return .giap
			}
		}
	}

	public enum Chi: String {
		case ti = "Tý"
		case suu = "Sửu"
		case dan = "Dần"
		case mao = "Mão"
		case thin = "Thìn"
		case ty = "Tỵ"
		case ngo = "Ngọ"
		case mui = "Mùi"
		case than = "Thân"
		case dau = "Dậu"
		case tuat = "Tuất"
		case hoi = "Hợi"

		static func yearAtIndex(_ index: Int) -> Chi {
			switch index {
				case 0: return .ti
				case 1: return .suu
				case 2: return .dan
				case 3: return .mao
				case 4: return .thin
				case 5: return .ty
				case 6: return .ngo
				case 7: return .mui
				case 8: return .than
				case 9: return .dau
				case 10: return .tuat
				case 11: return .hoi
				default: return .ti
			}
		}

		static func dayOrMonthAtIndex(_ index: Int) -> Chi {
			switch index {
				case 0: return .dan
				case 1: return .mao
				case 2: return .thin
				case 3: return .ty
				case 4: return .ngo
				case 5: return .mui
				case 6: return .than
				case 7: return .dau
				case 8: return .tuat
				case 9: return .hoi
				case 10: return .ti
				case 11: return .suu
				default: return .dan
			}
		}
	}

	public enum Holidays: String {
		case tetDuongLich       = "Tết Dương Lịch" // 1/1 dl
		case dcsVN              = "Ngày Thành Lập Đảng Cộng Sản Việt Nam\n(1930)" // 3/2 dl
		case valentine          = "Lễ Tình Nhân" // 14/2 dl
		case thayThuocVN        = "Ngày Thầy Thuốc Việt Nam" // 27/2 dl
		case quocTePhuNu        = "Ngày Quốc Tế Phụ Nữ" // 8/3 dl
		case thanhLapDoanTNCS   = "Ngày Thành Lập Đoàn Thanh Niên Cộng Sản Hồ Chí Minh" // 26/3 dl
		case caThangTu          = "Ngày Cá Tháng Tư" // 1/4 dl
		case giaiPhongMienNam   = "Ngày Giải Phóng Miền Nam\n(30/4/1975)" // 30/4 dl
		case quocTeLaoDong      = "Ngày Quốc Tế Lao Động" // 1/5 dl
		case snHCM              = "Ngày sinh Chủ tịch Hồ Chí Minh\n(19/5/1890)" // 19/5 dl
		case quocTeThieuNhi     = "Ngày Quốc Tế Thiếu Nhi" // 1/6 dl
		case thuongBinhLietSi   = "Ngày Thương Binh Liệt Sĩ" // 27/7 dl
		case cmT8               = "Cách Mạng Tháng 8 thành công\n(19/8/1945)" // 19/8
		case quocKhanhVN        = "Ngày Quốc Khánh Việt Nam\n(2/9/1945)"  // 2/9 dl
		case phuNuVN            = "Ngày Phụ Nữ Việt Nam" // 20/10 dl
		case doanhNhanVN        = "Ngày Doanh Nhân Việt Nam" //
		case halloween          = "Ngày Halloween" // 30/10
		case nhaGiaoVN          = "Ngày Nhà Giáo Việt Nam" // 21/11
		case giangSinh          = "Lễ Giáng Sinh" // 24/12
		case gioToHungVuong     = "Ngày Giỗ Tổ Hùng Vương" // 10/3 al
		case tetDoanNgo         = "Tết Đoan Ngọ (Diệt Sâu Bọ)" // 5/5 al
		case trungThu           = "Tết Trung Thu"    // 15/8 al
		case taoQuanVeTroi      = "Táo Quân Chầu Trời" // 23/12 al
		case tetNguyenDan       = "Tết Nguyên Đán" // 1/1-3/1 al
		case tetNguyenTieu      = "Rằm Tháng Giêng - Tết Nguyên Tiêu" // 15/1 al
		case tetHanThuc         = "Tết Hàn Thực" // 3/3 al
		case tetKhmer           = "Tết Dân tộc Khmer" // 14/4 al
		case lePhatDan          = "Lễ Phạt Đản" // 15/4 al
		case leVuLan            = "Lễ Vu Lan \nXá Tội Vong Nhân" // 15/7 al
		case leHoiKate          = "Lễ hội Katê" // 1/8 al
		case tetTrungCuu        = "Tết Trùng cửu" // 9/9 al
		case tetTrungThap       = "Tết Trùng thập" // 10/10 al
		case hoiChoiTrau        = "Lễ hội Chọi trâu Đồ Sơn" // 9/8 al
	}

	public enum Constants {
		static let timeZone: Int = 7
		static let pi: Double = 3.14159265359
	}

	public struct SLDate {
		public var day, month, year: Int
		public var islunarLeap: Bool = false

		public var isLeapYear: Bool {
			((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0))
		}

		public var daysOfMonth: Int {
			switch month {
				case 1, 3, 5, 7, 8, 10, 12: return 31
				case 4, 6, 9, 11: return 30
				default:
					return isLeapYear ? 29 : 28
			}
		}
	}

	public struct CanChi {
		public var can: Can
		public var chi: Chi
	}

	public class func toLunarDate(sun: SLDate, timeZone: Int = 7) -> SLDate {
		var lunarDay, lunarMonth, lunarYear: Int
		var lunarLeap: Bool = false

		let dayNumber = jdFromDate(sun)
		let k = ((dayNumber.doubleValue - 2415021.076998695) / 29.530588853).floorINT
		var monthStart = getNewMoonDay(k: k + 1, timeZone: timeZone)
		if monthStart > dayNumber {
			monthStart = getNewMoonDay(k: k, timeZone: timeZone)
		}

		var a11 = getLunarMonth11(year: sun.year, timeZone: timeZone)
		var b11 = a11
		if a11 >= monthStart {
			lunarYear = sun.year
			a11 = getLunarMonth11(year: sun.year - 1, timeZone: timeZone)
		} else {
			lunarYear = sun.year + 1
			b11 = getLunarMonth11(year: sun.year + 1, timeZone: timeZone)
		}

		lunarDay = dayNumber - monthStart + 1
		let diff = ((monthStart - a11).doubleValue / 29).floorINT
		lunarMonth = diff + 11
		if (b11 - a11) > 365 {
			let leapMonthDiff = getLunarMonth11(year: a11, timeZone: timeZone)
			if diff >= leapMonthDiff {
				lunarMonth = diff + 10
				if diff == leapMonthDiff {
					lunarLeap = true
				}
			}
		}

		if lunarMonth > 12 {
			lunarMonth = lunarMonth - 12;
		}
		if lunarMonth >= 11 && diff < 4 {
			lunarYear -= 1
		}

		return SLDate(day: lunarDay, month: lunarMonth, year: lunarYear, islunarLeap: lunarLeap)
	}

	public class func toSolarDate(lunar: SLDate, timZone: Int = 7) -> SLDate {
		var a11, b11: Int
		if lunar.month < 11 {
			a11 = getLunarMonth11(year: lunar.year - 1, timeZone: timZone)
			b11 = getLunarMonth11(year: lunar.year, timeZone: timZone)
		} else {
			a11 = getLunarMonth11(year: lunar.year, timeZone: timZone)
			b11 = getLunarMonth11(year: lunar.year + 1, timeZone: timZone)
		}
		let k = (0.5 + (a11.doubleValue - 2415021.076998695) / 29.530588853).floorINT
		var off = lunar.month - 11
		if off < 0 { off += 12 }
		if (b11 - a11 > 365) {
			let leapOff = getLeapMonthOffset(a11: a11, timeZone: timZone)
			var leapMonth = leapOff - 2
			if (leapMonth < 0) { leapMonth += 12 }
			if (lunar.islunarLeap && lunar.month != leapMonth) {
				return SLDate(day: 0, month: 0, year: 0)
			} else if (lunar.islunarLeap || off >= leapOff) {
				off += 1
			}
		}

		let monthStart = getNewMoonDay(k: k + off, timeZone: timZone)
		return jdToDate(jd: (monthStart + lunar.day - 1))
	}
}

public extension VNCalendar {
	/**
	*
	* @param dd
	* @param mm
	* @param yy
	* @return the number of days since 1 January 4713 BC (Julian calendar)
	*/
	class func jdFromDate(_ date: SLDate) -> Int {
		let a = (14 - date.month) / 12
		let y = date.year + 4800 - a
		let m = date.month + 12 * a - 3
		var jd = date.day + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045
		if (jd < 2299161) {
			jd = date.day + (153 * m + 2) / 5 + 365 * y + y / 4 - 32083
		}
		return jd
	}

	class func jdToDate(jd: Int) -> SLDate {
		var b: Int, c: Int

		if jd > 2299160 {
			let a = jd + 32044
			b = (4 * a + 3) / 146097
			c = a - (b * 146097) / 4
		} else {
			b = 0
			c = jd + 32082
		}

		let d = (4 * c + 3) / 1461
		let e = c - (1461 * d) / 4
		let m = (5 * e + 2) / 153
		let day = e - (153 * m + 2) / 5 + 1
		let month = m + 3 - 12 * (m / 10)
		let year = b * 100 + d - 4800 + m / 10
		return SLDate(day: day, month: month, year: year)
	}

	class func newMoonAA98(k: Int) -> Double {
		let t: Double = k.doubleValue / 1236.85
		let t2: Double = pow(t, 2)
		let t3: Double = pow(t, 3)
		let dr: Double = Constants.pi / 180.0
		var jd1: Double = 2415020.75933 + 29.53058868 * k.doubleValue + 0.0001178 * t2 - 0.000000155 * t3
		jd1 = jd1 + 0.00033 * sin((166.56 + 132.87 * t - 0.009173 * t2) * dr)
		let m = 359.2242 + 29.10535608 * k.doubleValue - 0.0000333 * t2 - 0.00000347 * t3
		let mpr = 306.0253 + 385.81691806 * k.doubleValue + 0.0107306 * t2 + 0.00001236 * t3
		let f = 21.2964 + 390.67050646 * k.doubleValue - 0.0016528 * t2 - 0.00000239 * t3
		var c1 = (0.1734 - 0.000393 * t) * sin(m * dr) + 0.0021 * sin(2 * dr * m)
		c1 = c1 - 0.4068 * sin(mpr * dr) + 0.0161 * sin(dr * 2 * mpr)
		c1 = c1 - 0.0004 * sin(dr * 3 * mpr)
		c1 = c1 + 0.0104 * sin(dr * 2 * f) - 0.0051 * sin(dr * (m + mpr))
		c1 = c1 - 0.0074 * sin(dr * (m - mpr)) + 0.0004 * sin(dr * (2 * f + m))
		c1 = c1 - 0.0004 * sin(dr * (2 * f - m)) - 0.0006 * sin(dr * (2 * f + mpr))
		c1 = c1 + 0.0010 * sin(dr * (2 * f - mpr)) + 0.0005 * sin(dr * (2 * mpr + m))
		var delta: Double

		if t < -11 {
			delta = 0.001 + 0.000839 * t + 0.0002261 * t2 - 0.00000845 * t3 - 0.000000081 * t * t3
		} else {
			delta = -0.000278 + 0.000265 * t + 0.000262 * t2
		}

		return jd1 + c1 - delta
	}

	class func getNewMoonDay(k: Int, timeZone: Int = 7) -> Int {
		let jd = newMoonAA98(k: k)
		return (jd + 0.5 + timeZone.doubleValue / 24).floorINT
	}

	class func sunLongitudeAA98(jdn: Double) -> Double {
		let t = (jdn - 2451545.0) / 36525
		let t2: Double = pow(t, 2)
		let dr = Constants.pi / 180
		let m = 357.52910 + 35999.05030 * t - 0.0001559 * t2 - 0.00000048 * t * t2
		let l0 = 280.46645 + 36000.76983 * t + 0.0003032 * t2
		var dl = (1.914600 - 0.004817 * t - 0.000014 * t2) * sin(dr * m)
		dl = dl + (0.019993 - 0.000101 * t) * sin(dr * 2 * m) + 0.000290 * sin(dr * 3 * m)
		var longitude = l0 + dl
		longitude = longitude - 360 * (longitude / 360).floorINT.doubleValue
		return longitude
	}

	class func getSunLongitude(days: Int, timeZone: Int = 7) -> Double {
		sunLongitudeAA98(jdn: days.doubleValue - 0.5 - timeZone.doubleValue / 24.0)
	}

	class func getLunarMonth11(year: Int, timeZone: Int = 7) -> Int {
		let off = jdFromDate(SLDate(day: 31, month: 12, year: year)).doubleValue - 2415021.076998695
		let k = (off / 29.530588853).floorINT.doubleValue
		var nm = getNewMoonDay(k: k.floorINT, timeZone: timeZone)
		let sunLong = (getSunLongitude(days: nm, timeZone: timeZone) / 30).floorINT

		if sunLong >= 9 {
			nm = getNewMoonDay(k: (k - 1).intValue, timeZone: timeZone)
		}
		return nm
	}

	class func getLeapMonthOffset(a11: Int, timeZone: Int = 7) -> Int {
		let k = (0.5 + (a11.doubleValue - 2415021.076998695) / 29.530588853).floorINT
		var arc = (getSunLongitude(days: getNewMoonDay(k: k + 1, timeZone: timeZone), timeZone: timeZone) / 30).floorINT
		var offset: Int = 1, last: Int
		repeat {
			last = arc
			offset += 1
			arc = (getSunLongitude(days: getNewMoonDay(k: k + offset, timeZone: timeZone), timeZone: timeZone) / 30).floorINT
		} while (arc != last && offset < 14)

		return offset - 1
	}
}

extension VNCalendar.Chi {
	static func fromHour(_ h: Int) -> VNCalendar.Chi {
		if (h == 23 || (h >= 0 && h <= 1)) { return .ti }
		else if (h > 1 && h <= 3) { return .suu }
		else if (h > 3 && h <= 5) { return .dan }
		else if (h > 5 && h <= 7) { return .mao }
		else if (h > 7 && h <= 9) { return .thin }
		else if (h > 9 && h <= 11) { return .ty }
		else if (h > 11 && h <= 13) { return .ngo }
		else if (h > 13 && h <= 15) { return .mui }
		else if (h > 15 && h <= 17) { return .than }
		else if (h > 17 && h <= 19) { return .dau }
		else if (h > 19 && h <= 21) { return .tuat }
		else if (h > 21 && h <= 23) { return .hoi }
		return .ti
	}
}

extension VNCalendar.SLDate {
	var dayCanChi: VNCalendar.CanChi {
		let index = VNCalendar.jdFromDate(self)
		let can = VNCalendar.Can.atIndex((index + 9) % 10)
		let chi = VNCalendar.Chi.dayOrMonthAtIndex((index + 11) % 12)
		return VNCalendar.CanChi(can: can, chi: chi)
	}

	var monthCanChi: VNCalendar.CanChi {
		let lunar = VNCalendar.toLunarDate(sun: self)
		let indexCan = (lunar.year * 12 + lunar.month + 3) % 10
		let can = VNCalendar.Can.atIndex(indexCan)
		let chi = VNCalendar.Chi.dayOrMonthAtIndex(lunar.month - 1)
		return VNCalendar.CanChi(can: can, chi: chi)
	}

	var yearCanChi: VNCalendar.CanChi {
		let lunar = VNCalendar.toLunarDate(sun: self)
		let can = VNCalendar.Can.atIndex((lunar.year + 6) % 10)
		let chi = VNCalendar.Chi.dayOrMonthAtIndex((lunar.year + 8) % 12)
		return VNCalendar.CanChi(can: can, chi: chi)
	}
}
