//
//  Date+Extension.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation

extension Date {
  func format() -> String {
    let formatter = DateFormatter()
    if Calendar.current.isDateInToday(self) {
      formatter.dateFormat = "h:mm a"
    } else {
      formatter.dateFormat = "dd/MM/yy"
    }
    return formatter.string(from: self)
  }
}
