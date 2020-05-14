//
//  String+Regex.swift
//  RxTimesTable
//
//  Created by Myeong Soo on 2020/02/12.
//  Copyright © 2020 Myeong Soo. All rights reserved.
//

import Foundation

extension String {
    func hasCharaters() -> Bool {
        do {
            let regrex = try NSRegularExpression(pattern: "^[0-9]$", options: .caseInsensitive)
            if let _ = regrex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        return false
    }
}
