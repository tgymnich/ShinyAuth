//
//  Extensions.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 21.8.20.
//

import Foundation

extension String {

    func group(groupSize : Int, divider: String = " ") -> String {
        let groups = self.reduce([]) { (acc, c) -> [String] in
            if let last = acc.last, last.count < groupSize {
                var result = acc.dropLast()
                result.append(last.appending(String(c)))
                return Array(result)
            } else {
                var result = acc
                result.append(String(c))
                return result
            }
        }
        return groups.joined(separator: divider)
    }

}
