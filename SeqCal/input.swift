//
//  input.swift
//  SeqCal
//
//  Created by Philipp Günther on 10.02.2017.
//  Copyright © 2017 Philipp Günther. All rights reserved.
//

import Foundation


fileprivate func nextRange(in text: String) -> Range<String.Index> {
    var opt: Range<String.Index>? = nil
    
    for keyword in [Keyword.not, Keyword.and, Keyword.or, Keyword.impl, Keyword.bracketL, Keyword.bracketR, Keyword.delimiter, Keyword.follows] {
        if let new = text.range(of: keyword.rawValue) {
            if let old = opt {
                if new.lowerBound < old.lowerBound {
                    opt = new
                }
            } else {
                opt = new
            }
        }
    }
    
    if let r = opt {
        if r.lowerBound == text.startIndex {
            return r
        } else {
            return Range<String.Index>(uncheckedBounds: (lower: text.startIndex, upper: r.lowerBound))
        }
    } else {
        return Range<String.Index>(uncheckedBounds: (lower: text.startIndex, upper: text.endIndex))
    }
}

fileprivate func tokenize(from text: String) -> [String] {
    var tokens: [String] = []
    var resid = text.replacingOccurrences(of: " ", with: "")
    
    while !resid.isEmpty {
        let range = nextRange(in: resid)
        tokens += [resid.substring(with: range)]
        resid.removeSubrange(range)
    }
    
    return tokens
}


fileprivate func parse(from tokens: [String]) -> Formula {
    // !TODO
    return Formula.and(
        lhs: Formula.x("X"),
        rhs: Formula.x("Y")
    )
}

fileprivate func parse(from tokens: [String]) -> [Formula] {
    return tokens.split(separator: ",").map({f in parse(from: Array(f))})
}

fileprivate func parse(from tokens: [String]) -> Theorem {
    return Theorem(
        assumptions: [parse(from: Array(tokens.split(separator: "=>", maxSplits: 1, omittingEmptySubsequences: false)[0]))],
        conclusions: [parse(from: Array(tokens.split(separator: "=>", maxSplits: 1, omittingEmptySubsequences: false)[1]))]
    )
}

public func parse(from text: String) -> Theorem {
    print(text)
    let theorem: Theorem = parse(from: tokenize(from: text))
    print(theorem)
    
    print("\n")
    
    return theorem
}
