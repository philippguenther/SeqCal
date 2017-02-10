//
//  output.swift
//  SeqCal
//
//  Created by Philipp Günther on 10.02.2017.
//  Copyright © 2017 Philipp Günther. All rights reserved.
//

import Foundation


public func text(r: Rule) -> String {
    switch (r) {
    case .not_:
        return "not =>"
    case ._not:
        return "=> not"
    case .and_:
        return "and =>"
    case ._and:
        return "=> and"
    case .or_:
        return "or =>"
    case ._or:
        return "=> or"
    case .impl_:
        return "-> =>"
    case ._impl:
        return "=> ->"
    }
}

public func text(f: Formula) -> String {
    switch (f) {
    case .x(let name):
        return name
    case .not(let x):
        return "(" + "not" + text(f: x) + ")"
    case .and(let l, let r):
        return "(" + text(f: l) + " and " + text(f: r) + ")"
    case .or(let l, let r):
        return "(" + text(f: l) + " or " + text(f: r) + ")"
    case .impl(let l, let r):
        return "(" + text(f: l) + " -> " + text(f: r) + ")"
    }
}

public func text(t: Theorem) -> String {
    return t.assumptions.map({a in text(f: a)}).joined(separator: ", ")
        + " => "
        + t.conclusions.map({c in text(f: c)}).joined(separator: ", ")
}

public func text(s: Sequent) -> String {
    var queue = [s]
    var str = ""
    
    while !queue.isEmpty {
        switch (queue.remove(at: 0)) {
        case .axiom(let t), .theorem(let t):
            str = "\t\t" + text(t: t) + "\n" + str
        case .sequent(let t, let premises, let rule):
            str = text(r: rule) + "\t" + text(t: t) + "\n" + str
            queue += premises
        }
    }
    
    return str
}






