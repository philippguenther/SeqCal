//
//  output.swift
//  SeqCal
//
//  Created by Philipp Günther on 10.02.2017.
//  Copyright © 2017 Philipp Günther. All rights reserved.
//

import Foundation


extension Rule: CustomStringConvertible {
    public var description: String {
        switch (self) {
        case .not_:
            return Keyword.not.rawValue + " " + Keyword.follows.rawValue
        case ._not:
            return Keyword.follows.rawValue + " " + Keyword.not.rawValue
        case .and_:
            return Keyword.and.rawValue + " " + Keyword.follows.rawValue
        case ._and:
            return Keyword.follows.rawValue + " " + Keyword.and.rawValue
        case .or_:
            return Keyword.or.rawValue + " " + Keyword.follows.rawValue
        case ._or:
            return Keyword.follows.rawValue + " " + Keyword.or.rawValue
        case .impl_:
            return Keyword.impl.rawValue + " " + Keyword.follows.rawValue
        case ._impl:
            return Keyword.follows.rawValue + " " + Keyword.impl.rawValue
        }
    }
}

extension Formula: CustomStringConvertible {
    public var description: String {
        switch (self) {
        case .x(let name):
            return name
        case .not(let x):
            return Keyword.bracketL.rawValue + Keyword.not.rawValue + x.description + Keyword.bracketR.rawValue
        case .and(let l, let r):
            return Keyword.bracketL.rawValue + l.description + " " + Keyword.and.rawValue + " " + r.description + Keyword.bracketR.rawValue
        case .or(let l, let r):
            return Keyword.bracketL.rawValue + l.description + " " + Keyword.or.rawValue + " " + r.description + Keyword.bracketR.rawValue
        case .impl(let l, let r):
            return Keyword.bracketL.rawValue + l.description + " " + Keyword.impl.rawValue + " " + r.description + Keyword.bracketR.rawValue
        }
    }
}

extension Theorem: CustomStringConvertible {
    public var description: String {
        return self.assumptions.map({a in a.description}).joined(separator: Keyword.delimiter.rawValue)
            + " " + Keyword.follows.rawValue + " "
            + self.conclusions.map({c in c.description}).joined(separator: Keyword.delimiter.rawValue)
    }
}

extension Sequent: CustomStringConvertible {
    public var description: String {
        var queue = [self]
        var str = ""
        
        while !queue.isEmpty {
            switch (queue.remove(at: 0)) {
            case .axiom(let t), .theorem(let t):
                str = "\t\t" + t.description + "\n" + str
            case .sequent(let t, let premises, let rule):
                str = rule.description + "\t" + t.description + "\n" + str
                queue += premises
            }
        }
        
        return str
    }
}
