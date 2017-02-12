//
//  solver.swift
//  SeqCal
//
//  Created by Philipp Günther on 10.02.2017.
//  Copyright © 2017 Philipp Günther. All rights reserved.
//

import Foundation


fileprivate func derive(_ t: Theorem) -> Sequent {
    // not =>
    if let theta = t.assumptions.filter({a in if case .not(_) = a {return true} else {return false}}).first,
            case .not(let phi) = theta {
        return Sequent.sequent(theorem: t, premises: [
            Sequent.theorem(Theorem(
                assumptions: t.assumptions.filter({a in a != theta}),
                conclusions: t.conclusions + [phi]
            ))
        ], rule: .not_)
    }
        
    // => not
    else if let theta = t.conclusions.filter({a in if case .not(_) = a {return true} else {return false}}).first,
            case .not(let phi) = theta {
        return Sequent.sequent(theorem: t, premises: [
            Sequent.theorem(Theorem(
                assumptions: t.assumptions + [phi],
                conclusions: t.conclusions.filter({c in c != theta})
            ))
        ], rule: ._not)
    }
        
    // and =>
    else if let theta = t.assumptions.filter({a in if case .and(_, _) = a {return true} else {return false}}).first,
            case .and(let phi, let psi) = theta {
        return Sequent.sequent(theorem: t, premises: [
            Sequent.theorem(Theorem(
                assumptions: t.assumptions.filter({a in a != theta}) + [phi, psi],
                conclusions: t.conclusions
            ))
        ], rule: .and_)
    }
        
    // => and
    else if let theta = t.conclusions.filter({a in if case .and(_, _) = a {return true} else {return false}}).first,
            case .and(let phi, let psi) = theta {
        return Sequent.sequent(theorem: t, premises: [
            Sequent.theorem(Theorem(
                assumptions: t.assumptions,
                conclusions: t.conclusions.filter({c in c != theta}) + [phi]
            )), Sequent.theorem(Theorem(
                assumptions: t.assumptions,
                conclusions: t.conclusions.filter({c in c != theta}) + [psi]
            ))
        ], rule: ._and)
    }
        
    // or =>
    else if let theta = t.assumptions.filter({a in if case .or(_, _) = a {return true} else {return false}}).first,
            case .or(let phi, let psi) = theta {
        return Sequent.sequent(theorem: t, premises: [
            Sequent.theorem(Theorem(
                assumptions: t.assumptions.filter({a in a != theta}) + [phi],
                conclusions: t.conclusions
            )), Sequent.theorem(Theorem(
                assumptions: t.assumptions.filter({a in a != theta}) + [psi],
                conclusions: t.conclusions
            ))
        ], rule: .or_)
    }
        
    // => or
    else if let theta = t.conclusions.filter({a in if case .or(_, _) = a {return true} else {return false}}).first,
            case .or(let phi, let psi) = theta {
        return Sequent.sequent(theorem: t, premises: [
            Sequent.theorem(Theorem(
                assumptions: t.assumptions,
                conclusions: t.conclusions.filter({c in c != theta}) + [phi, psi]
            ))
        ], rule: ._or)
    }
        
    // -> =>
    else if let theta = t.assumptions.filter({a in if case .impl(_, _) = a {return true} else {return false}}).first,
            case .impl(let phi, let psi) = theta {
        return Sequent.sequent(theorem: t, premises: [
            Sequent.theorem(Theorem(
                assumptions: t.assumptions.filter({a in a != theta}),
                conclusions: t.conclusions + [phi]
            )), Sequent.theorem(Theorem(
                assumptions: t.assumptions.filter({a in a != theta}) + [psi],
                conclusions: t.conclusions
            ))
        ], rule: .impl_)
    }
        
    // => ->
    else if let theta = t.conclusions.filter({a in if case .impl(_, _) = a {return true} else {return false}}).first,
            case .impl(let phi, let psi) = theta {
        return Sequent.sequent(theorem: t, premises: [
            Sequent.theorem(Theorem(
                assumptions: t.assumptions + [phi],
                conclusions: t.conclusions.filter({c in c != theta}) + [psi]
            ))
        ], rule: ._impl)
    }
    
    else {
        return Sequent.axiom(t)
    }
}

public func proof(_ s: Sequent) -> Sequent {
    switch (s) {
    case .axiom(_):
        return s
    case .theorem(let t):
        return proof(derive(t))
    case .sequent(let t, let premises, let rule):
        return Sequent.sequent(theorem: t, premises: premises.map({p in proof(p)}), rule: rule)
    }
}
