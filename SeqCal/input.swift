//
//  input.swift
//  SeqCal
//
//  Created by Philipp Günther on 10.02.2017.
//  Copyright © 2017 Philipp Günther. All rights reserved.
//

import Foundation


fileprivate func tokenize(text: String) -> [String] {
    return ["X", "and", "Y", "=>", "X", "or", "Y"]
}

public func parse(text: String) -> Theorem {
//        return Theorem(
//            assumptions: [
//                Formula.and(
//                    lhs: Formula.x("X"),
//                    rhs: Formula.x("Y")
//                )
//            ],
//            conclusions: [
//                Formula.or(
//                    lhs: Formula.x("X"),
//                    rhs: Formula.x("Y")
//                )
//            ]
//        )
    
    return Theorem(
        assumptions: [],
        conclusions: [
            Formula.impl(
                lhs: Formula.impl(
                    lhs: Formula.x("X"),
                    rhs: Formula.x("Y")
                ),
                rhs: Formula.impl(
                    lhs: Formula.not(Formula.x("Y")),
                    rhs: Formula.not(Formula.x("X"))
                )
            )
        ]
    )
}
