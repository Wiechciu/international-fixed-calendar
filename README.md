# International Fixed Calendar

- [✨ Features](#-features)
- [📦 Installation](#-installation)
- [⚙️ Usage](#️-usage)
- [🤝 Contributing](#-contributing)
- [📜 License](#-license)

Godot plugin to convert [Gregorian Calendar](https://en.wikipedia.org/wiki/Gregorian_calendar) dates to [International Fixed Calendar](https://en.wikipedia.org/wiki/International_Fixed_Calendar) (IFC) dates and vice versa.

International Fixed Calendar simplifies the commonly used Gregorian Calendar by implementing a few changes:

- Each week consists of 7 days,
- Each month consists of 4 weeks,
- Each month consist of 7 * 4 = 28 days,
- Each year consists of 13 months, new month named _Sol_ is introduced between June and July,
- Each year consists of 7 * 4 * 13 = 364 standard days and either 1 or 2 special days: _New Year Day_ for all years and _Leap Year Day_ for leap years only,
- Each week starts with Monday and ends with Sunday, according to ISO-8601 standard,
- Special days: _New Year Day_ and _Leap Year Day_ are officially not part of any week, nor month, nor bear any standard weekday name. For simplicity, these are represented as follows:
  - New Year Day is added at the end of the last month and is represented as YYYY-13-29,
  - In leap years, the Leap Year Day is added at the end of the 6th month and is represented as YYYY-06-29,
  - Weekday name is _Sunday_.

<img width="250" height="232.25" alt="image" src="https://github.com/user-attachments/assets/f279e573-1105-4449-9e9e-ef32883abfb5" />

_Credit to [this Reddit post](https://www.reddit.com/r/ISO8601/comments/i5kjsk/the_international_fixed_calendar_but_actually/)_

---

### ✨ Features
- Accepts and returns dates in `Dictionary`, `String` or Unix time (`int`) format,
- Compatible with Godot's built-in [Time](https://docs.godotengine.org/en/stable/classes/class_time.html) class,
- Correctly accounts for leap years.

---

### 📦 Installation

1. Copy the `addons/international_fixed_calendar/` folder into your Godot project’s `addons/` directory  
2. In Godot, go to **Project > Project Settings > Plugins**  
3. Enable **International Fixed Calendar**

---

### ⚙️ Usage

Plugin creates an autoload `IFC` (International Fixed Calendar) that can be accessed anywhere in the codebase. E.g. providing date from Gregorian Calendar format:
```
IFC.get_ifc_date_string_from_gregorian_date_string("2025-06-10")
```
Returns IFC date equivalent: `2025-07-13`.

The other way around, providing date in IFC format:
```
IFC.get_gregorian_date_string_from_ifc_date_string("2025-13-29")
```
Returns Gregorian Calendar date equivalent: `2025-12-31`.

---

### 🤝 Contributing

Pull requests, bug reports, and suggestions are welcome!
If you’d like to add features, feel free to fork and submit a PR.

---

### 📜 License

[MIT License](https://github.com/Wiechciu/international-fixed-calendar?tab=MIT-1-ov-file) – feel free to use in commercial or open-source projects.
