//
//  core.swift
//  SeqCal
//
//  Created by Philipp Günther on 10.02.2017.
//  Copyright © 2017 Philipp Günther. All rights reserved.
//

import Foundation


public indirect enum Formula: Equatable {
    case x(String)
    case not(Formula)
    case and(lhs: Formula, rhs: Formula)
    case or(lhs: Formula, rhs: Formula)
    case impl(lhs: Formula, rhs: Formula)
}

public func ==(lhs: Formula, rhs: Formula) -> Bool {
    switch (lhs, rhs) {
    case (let .x(x1), let .x(x2)):
        return x1 == x2
    case (let .not(x1), let .not(x2)):
        return x1 == x2
    case (let .and(lhs: l1, rhs: r1), let .and(lhs: l2, rhs: r2)):
        return l1 == l2 && r1 == r2
    case (let .or(lhs: l1, rhs: r1), let .or(lhs: l2, rhs: r2)):
        return l1 == l2 && r1 == r2
    case (let .impl(lhs: l1, rhs: r1), let .impl(lhs: l2, rhs: r2)):
        return l1 == l2 && r1 == r2
    default:
        return false
    }
}

public enum Rule {
    case not_
    case _not
    case and_
    case _and
    case or_
    case _or
    case impl_
    case _impl
}

public struct Theorem {
    let assumptions: [Formula]
    let conclusions: [Formula]
}

public indirect enum Sequent {
    case axiom(Theorem)
    case theorem(Theorem)
    case sequent(theorem: Theorem, premises: [Sequent], rule: Rule)
}
