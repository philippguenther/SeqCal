//
//  main.swift
//  SeqCal
//
//  Created by Philipp Günther on 08.02.2017.
//  Copyright © 2017 Philipp Günther. All rights reserved.
//

import Foundation


indirect enum Formula: Equatable {
    case x(String)
    case not(Formula)
    case and(lhs: Formula, rhs: Formula)
    case or(lhs: Formula, rhs: Formula)
    case impl(lhs: Formula, rhs: Formula)
}

func ==(lhs: Formula, rhs: Formula) -> Bool {
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

struct Theorem {
    let assumptions: [Formula]
    let conclusions: [Formula]
}

enum Sequent {
    case axiom(Theorem)
    case theorem(Theorem)
    case sequent(theorem: Theorem, premises: [Sequent])
}


func tokenize(text: String) -> [String] {
    return ["X", "and", "Y", "=>", "X", "or", "Y"]
}

func parse(tokens: [String]) -> Theorem {
//    return Theorem(
//        assumptions: [
//            Formula.and(
//                lhs: Formula.x("X"),
//                rhs: Formula.x("Y")
//            )
//        ],
//        conclusions: [
//            Formula.or(
//                lhs: Formula.x("X"),
//                rhs: Formula.x("Y")
//            )
//        ]
//    )
    
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


func derive(t: Theorem) -> Sequent {
    var premises: [Theorem] = []
    
    // not =>
    if let theta = t.assumptions.filter({a in if case .not(_) = a {return true} else {return false}}).first {
        if case .not(let psi) = theta {
            premises.append(Theorem(
                assumptions: t.assumptions.filter({a in a != theta}),
                conclusions: t.conclusions + [psi]))
        }
    }
    
    // => not
    else if let theta = t.conclusions.filter({a in if case .not(_) = a {return true} else {return false}}).first {
        if case .not(let psi) = theta {
            premises.append(Theorem(
                assumptions: t.assumptions + [psi],
                conclusions: t.conclusions.filter({c in c != theta})))
        }
    }
    
    // => and
    else if let theta = t.conclusions.filter({a in if case .and(_, _) = a {return true} else {return false}}).first {
        if case .and(let l, let r) = theta {
            premises.append(Theorem(
                assumptions: t.assumptions,
                conclusions: t.conclusions.filter({c in c != theta}) + [l]))
            premises.append(Theorem(
                assumptions: t.assumptions,
                conclusions: t.conclusions.filter({c in c != theta}) + [r]))
        }
    }
    
    // and =>
    else if let theta = t.assumptions.filter({a in if case .and(_, _) = a {return true} else {return false}}).first {
        if case .and(let l, let r) = theta {
            premises.append(Theorem(
                assumptions: t.assumptions.filter({a in a != theta}) + [l, r],
                conclusions: t.conclusions))
        }
    }
    
    // => or
    else if let theta = t.conclusions.filter({a in if case .or(_, _) = a {return true} else {return false}}).first {
        if case .or(let l, let r) = theta {
            premises.append(Theorem(
                assumptions: t.assumptions,
                conclusions: t.conclusions.filter({c in c != theta}) + [l, r]))
        }
    }
    
    // or =>
    else if let theta = t.assumptions.filter({a in if case .or(_, _) = a {return true} else {return false}}).first {
        if case .or(let l, let r) = theta {
            premises.append(Theorem(
                assumptions: t.assumptions.filter({a in a != theta}) + [l],
                conclusions: t.conclusions))
            premises.append(Theorem(
                assumptions: t.assumptions.filter({a in a != theta}) + [r],
                conclusions: t.conclusions))
        }
    }
    
    // => impl
    else if let theta = t.conclusions.filter({a in if case .impl(_, _) = a {return true} else {return false}}).first {
        if case .impl(let l, let r) = theta {
            premises.append(Theorem(
                assumptions: t.assumptions + [l],
                conclusions: t.conclusions.filter({c in c != theta}) + [r]))
        }
    }
    
    // impl =>
    else if let theta = t.assumptions.filter({a in if case .impl(_, _) = a {return true} else {return false}}).first {
        if case .impl(let l, let r) = theta {
            premises.append(Theorem(
                assumptions: t.assumptions.filter({a in a != theta}),
                conclusions: t.conclusions + [l]))
            premises.append(Theorem(
                assumptions: t.assumptions.filter({a in a != theta}) + [r],
                conclusions: t.conclusions))
        }
    }
    
    if (premises.count == 0) {
        return Sequent.sequent(theorem: t, premises: [Sequent.axiom(t)])
    } else {
        return Sequent.sequent(theorem: t, premises: premises.map({p in Sequent.theorem(p)}))
    }
    
}

func proof(s: Sequent) -> Sequent {
    switch (s) {
    case .axiom(_):
        return s
    case .theorem(let t):
        return proof(s: derive(t: t))
    case .sequent(let t, let premises):
        return Sequent.sequent(theorem: t, premises: premises.map({p in proof(s: p)}))
    }
}


func text(f: Formula) -> String {
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

func text(t: Theorem) -> String {
    return t.assumptions.map({a in text(f: a)}).joined(separator: ", ")
        + " => "
        + t.conclusions.map({c in text(f: c)}).joined(separator: ", ")
}

func text(s: Sequent) -> String {
    switch (s) {
    case .axiom(let t):
        return text(t: t)
    case .theorem(let t):
        return text(t: t)
    case .sequent(let t, let ps):
        return ps.map{p in text(s: p)}.joined(separator: "  |  ") + "\n---\n" + text(t: t)
    }
}


print(text(s: proof(s: Sequent.theorem(parse(tokens: tokenize(text: "X and Y => X or Y"))))))



















