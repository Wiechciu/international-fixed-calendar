# IFC autoload
extends Node


const DAYS_IN_ONE_WEEK: int = 7
const WEEKS_IN_ONE_MONTH: int = 4
const MONTHS_IN_ONE_YEAR: int = 13

const DAYS_IN_ONE_MONTH: int = DAYS_IN_ONE_WEEK * WEEKS_IN_ONE_MONTH
const DAYS_IN_ONE_YEAR: int = DAYS_IN_ONE_MONTH * MONTHS_IN_ONE_YEAR

const LAST_MONTH: int = MONTHS_IN_ONE_YEAR
const LAST_DAY_NUMBER: int = DAYS_IN_ONE_YEAR + 1
const LEAP_DAY_MONTH: int = 6
const LEAP_DAY_NUMBER: int = LEAP_DAY_MONTH * DAYS_IN_ONE_MONTH + 1

const WEEKDAY_NAMES: PackedStringArray = [
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
	"Sunday",
]

const MONTH_NAMES: PackedStringArray = [
	"January",
	"February",
	"March",
	"April",
	"May",
	"June",
	"Sol",
	"July",
	"August",
	"September",
	"October",
	"November",
	"December",
]

enum StringFormat {
	ISO,
	WITH_MONTH_NAMES,
}


## Expects dictionary with year, month and day elements, all of type int, in gregorian calendar.
## Returns dictionary with year, month and day elements, all of type int, in international fixed calendar.
func get_ifc_date_dict_from_gregorian_date_dict(gregorian_date_dict: Dictionary) -> Dictionary:
	var ifc_date_dict: Dictionary = {}
	
	if not _is_valid_date_dict(gregorian_date_dict):
		ifc_date_dict.year = 0
		ifc_date_dict.month = 0
		ifc_date_dict.day = 0
		return ifc_date_dict
	
	var day_number: int = _get_day_number_from_gregorian_date_dict(gregorian_date_dict)
	var is_leap_year: bool = _is_leap_year(gregorian_date_dict.year)
	var is_leap_day: bool = day_number == LEAP_DAY_NUMBER
	var leaped_day_number: int = day_number - (1 if is_leap_year and day_number > LEAP_DAY_NUMBER else 0)
	var is_last_day: bool = leaped_day_number == LAST_DAY_NUMBER
	
	ifc_date_dict.year = gregorian_date_dict.year
	
	if is_last_day:
		ifc_date_dict.month = LAST_MONTH
		ifc_date_dict.day = DAYS_IN_ONE_MONTH + 1
	elif is_leap_year and is_leap_day:
		ifc_date_dict.month = LEAP_DAY_MONTH
		ifc_date_dict.day = DAYS_IN_ONE_MONTH + 1
	else:
		ifc_date_dict.month = ceili(leaped_day_number / float(DAYS_IN_ONE_MONTH))
		ifc_date_dict.day = wrapi(leaped_day_number, 1, 29)
	
	return ifc_date_dict


## Expects string in the YYYY-MM-DD format, in gregorian calendar.
## Returns dictionary with year, month and day elements, all of type int, in international fixed calendar.
func get_ifc_date_dict_from_gregorian_date_string(gregorian_date_string: String) -> Dictionary:
	if not _is_valid_date_string(gregorian_date_string):
		var ifc_date_dict: Dictionary = {}
		ifc_date_dict.year = 0
		ifc_date_dict.month = 0
		ifc_date_dict.day = 0
		return ifc_date_dict
	
	var gregorian_date_dict: Dictionary = Time.get_datetime_dict_from_datetime_string(gregorian_date_string, false)
	
	return get_ifc_date_dict_from_gregorian_date_dict(gregorian_date_dict)


## Expects dictionary with year, month and day elements, all of type int, in gregorian calendar.
## Returns string in the YYYY-MM-DD format, in international fixed calendar.
func get_ifc_date_string_from_gregorian_date_dict(gregorian_date_dict: Dictionary, string_format: StringFormat = StringFormat.ISO) -> String:
	var ifc_date_dict: Dictionary = get_ifc_date_dict_from_gregorian_date_dict(gregorian_date_dict)
	
	var ifc_date_string: String
	match string_format:
		StringFormat.ISO:
			ifc_date_string = "%04d-%02d-%02d" % [ifc_date_dict.year, ifc_date_dict.month, ifc_date_dict.day]
		StringFormat.WITH_MONTH_NAMES:
			ifc_date_string = "%04d %s %02d" % [ifc_date_dict.year, MONTH_NAMES[ifc_date_dict.month - 1], ifc_date_dict.day]
		_:
			ifc_date_string = "0000-00-00"
	
	return ifc_date_string


## Expects string in the YYYY-MM-DD format, in gregorian calendar.
## Returns string in the YYYY-MM-DD format, in international fixed calendar.
func get_ifc_date_string_from_gregorian_date_string(gregorian_date_string: String, string_format: StringFormat = StringFormat.ISO) -> String:
	if not _is_valid_date_string(gregorian_date_string):
		return "0000-00-00"
	
	var gregorian_date_dict: Dictionary = Time.get_datetime_dict_from_datetime_string(gregorian_date_string, false)
	
	return get_ifc_date_string_from_gregorian_date_dict(gregorian_date_dict, string_format)


## Expects unix time in int format.
## Returns string in the YYYY-MM-DD format, in international fixed calendar.
func get_ifc_date_string_from_unix_time(unix_time: int, string_format: StringFormat = StringFormat.ISO) -> String:
	var gregorian_date_dict: Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
	
	return get_ifc_date_string_from_gregorian_date_dict(gregorian_date_dict, string_format)


## Returns string in the YYYY-MM-DD format, in international fixed calendar.
func get_ifc_date_string_from_system(string_format: StringFormat = StringFormat.ISO) -> String:
	var gregorian_date_dict: Dictionary = Time.get_date_dict_from_system()
	
	return get_ifc_date_string_from_gregorian_date_dict(gregorian_date_dict, string_format)


## Expects dictionary with year, month and day elements, all of type int, in international fixed calendar. 
## Returns string in the YYYY-MM-DD format, in international fixed calendar.
func get_ifc_date_string_from_ifc_date_dict(ifc_date_dict: Dictionary, string_format: StringFormat = StringFormat.ISO) -> String:
	if not _is_valid_date_dict(ifc_date_dict):
		return "0000-00-00"
	
	return "%04d-%02d-%02d" % [ifc_date_dict.year, ifc_date_dict.month, ifc_date_dict.day]


## Expects string in the YYYY-MM-DD format, in international fixed calendar. 
## Returns dictionary with year, month and day elements, all of type int, in international fixed calendar.
func get_ifc_date_dict_from_ifc_date_string(ifc_date_string: String) -> Dictionary:
	var ifc_date_dict: Dictionary = {}
	if not _is_valid_date_string(ifc_date_string):
		ifc_date_dict.year = 0
		ifc_date_dict.month = 0
		ifc_date_dict.day = 0
	else:
		var splits: PackedStringArray = ifc_date_string.split("-")
		ifc_date_dict.year = int(splits[0])
		ifc_date_dict.month = int(splits[1])
		ifc_date_dict.day = int(splits[2])
	return ifc_date_dict


## Expects dictionary with year, month and day elements, all of type int, in international fixed calendar. 
## Returns unix time in int format.
func get_unix_time_from_ifc_date_dict(ifc_date_dict: Dictionary) -> int:
	var gregorian_date_dict: Dictionary = get_gregorian_date_dict_from_ifc_date_dict(ifc_date_dict)
	
	return Time.get_unix_time_from_datetime_dict(gregorian_date_dict)


## Expects string in the YYYY-MM-DD format, in international fixed calendar. 
## Returns unix time in int format.
func get_unix_time_from_ifc_date_string(ifc_date_string: String) -> int:
	var gregorian_date_dict: Dictionary = get_gregorian_date_dict_from_ifc_date_string(ifc_date_string)
	
	return Time.get_unix_time_from_datetime_dict(gregorian_date_dict)


## Expects dictionary with year, month and day elements, all of type int, in gregorian calendar. 
## Returns dictionary with year, month and day elements, all of type int, in international fixed calendar.
func get_gregorian_date_dict_from_ifc_date_dict(ifc_date_dict: Dictionary) -> Dictionary:
	if not _is_valid_date_dict(ifc_date_dict):
		var gregorian_date_dict: Dictionary = {}
		gregorian_date_dict.year = 0
		gregorian_date_dict.month = 0
		gregorian_date_dict.day = 0
		return gregorian_date_dict
	
	var day_number: int = _get_day_number_from_ifc_date_dict(ifc_date_dict)
	var first_day_unix_time: int = Time.get_unix_time_from_datetime_string("%04d-%02d-%02d" % [ifc_date_dict.year, 1, 1])
	
	return Time.get_date_dict_from_unix_time(first_day_unix_time + day_number * 60 * 60 * 24 - 1)


## Expects dictionary with year, month and day elements, all of type int, in international fixed calendar.
## Returns string in the YYYY-MM-DD format, in gregorian calendar.
func get_gregorian_date_string_from_ifc_date_dict(ifc_date_dict: Dictionary) -> String:
	if not _is_valid_date_dict(ifc_date_dict):
		return "0000-00-00"
	
	var day_number: int = _get_day_number_from_ifc_date_dict(ifc_date_dict)
	var first_day_unix_time: int = Time.get_unix_time_from_datetime_string("%04d-%02d-%02d" % [ifc_date_dict.year, 1, 1])
	
	return Time.get_date_string_from_unix_time(first_day_unix_time + day_number * 60 * 60 * 24 - 1)


## Expects string in the YYYY-MM-DD format, in international fixed calendar.
## Returns string in the YYYY-MM-DD format, in gregorian calendar.
func get_gregorian_date_string_from_ifc_date_string(ifc_date_string: String) -> String:
	var ifc_date_dict: Dictionary = get_ifc_date_dict_from_ifc_date_string(ifc_date_string)
	
	return get_gregorian_date_string_from_ifc_date_dict(ifc_date_dict)


## Expects string in the YYYY-MM-DD format, in international fixed calendar.
## Returns dictionary with year, month and day elements, all of type int, in gregorian calendar.
func get_gregorian_date_dict_from_ifc_date_string(ifc_date_string: String) -> Dictionary:
	var ifc_date_dict: Dictionary = get_ifc_date_dict_from_ifc_date_string(ifc_date_string)
	
	return get_gregorian_date_dict_from_ifc_date_dict(ifc_date_dict)


## Expects dictionary with year, month and day elements, all of type int, in gregorian calendar.
## Returns day number within the year, accounting for leap years.
func _get_day_number_from_gregorian_date_dict(gregorian_date_dict: Dictionary) -> int:
	var day_number: int
	var days_in_month = [31,
		(29 if _is_leap_year(gregorian_date_dict.year) else 28),
		31,30,31,30,31,31,30,31,30,31
	]
	
	if gregorian_date_dict.month > 1:
		for month: int in gregorian_date_dict.month - 1:
			day_number += days_in_month[month]
	
	day_number += gregorian_date_dict.day
	
	return day_number


## Expects dictionary with year, month and day elements, all of type int, in international fixed calendar.
## Returns day number within the year, accounting for leap years.
func _get_day_number_from_ifc_date_dict(ifc_date_dict: Dictionary) -> int:
	var day_number: int
	var days_in_month = [28,28,28,28,28,
		(29 if _is_leap_year(ifc_date_dict.year) else 28),
		28,28,28,28,28,28,28
	]
	
	if ifc_date_dict.month > 1:
		for month: int in ifc_date_dict.month - 1:
			day_number += days_in_month[month]
	
	day_number += ifc_date_dict.day
	
	return day_number


## Returns true if provided year is a leap year.
func _is_leap_year(year: int) -> bool:
	return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)


## Returns true if provided date string is valid.
func _is_valid_date_string(date_string: String) -> bool:
	var splits: PackedStringArray = date_string.split("-")
	if splits.size() != 3:
		return false
	
	var has_valid_year: bool = splits[0].is_valid_int() and int(splits[0]) > 0
	var has_valid_month: bool = splits[1].is_valid_int() and int(splits[1]) >= 1 and int(splits[1]) <= 12
	var has_valid_day: bool = splits[2].is_valid_int() and int(splits[2]) >= 1 and int(splits[2]) <= 31
	
	return has_valid_year and has_valid_month and has_valid_day


## Returns true if provided date dictionary is valid.
func _is_valid_date_dict(date_dict: Dictionary) -> bool:
	var has_valid_year: bool = date_dict.has("year") and date_dict.year is int and date_dict.year > 0
	var has_valid_month: bool = date_dict.has("month") and date_dict.month is int and date_dict.month >= 1 and date_dict.month <= 12
	var has_valid_day: bool = date_dict.has("day") and date_dict.day is int and date_dict.day >= 1 and date_dict.day <= 31
	
	return has_valid_year and has_valid_month and has_valid_day
