//
//  ArrayExtension.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 19/12/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import Foundation

/*
    CODE Found at https://stackoverflow.com/questions/27259332/get-random-elements-from-array-in-swift/27261991 by Leo Dabus
    CODE Implemented By Karel Heyndrickx
 */

extension Array {
    /// Returns an array containing this sequence shuffled
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
    /// Shuffles this sequence in place
    @discardableResult
    mutating func shuffle() -> Array {
        let count = self.count
        indices.lazy.dropLast().forEach {
            swapAt($0, Int(arc4random_uniform(UInt32(count - $0))) + $0)
        }
        return self
    }
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}
