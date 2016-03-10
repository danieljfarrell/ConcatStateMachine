//
//  ConcatState.swift
//  ConcatStateMachine
//
//  Created by Daniel Farrell on 27/02/2016.
//  Copyright © 2016 ExcitonLabs. All rights reserved.
//

import Foundation

/* This enum defines the state and allowed transitions for the 
importing working flow. */
enum ConcatState: StateMachineDataSource {
    
    case Empty
    case Inserting([FileItem], NSIndexSet?) // FileItem is our model object
    case Loading( () -> () ) // Call back block when loaded finishes
    case Ready
    
    func shouldTransitionFrom(from:ConcatState, to: ConcatState) -> Should<ConcatState> {
        switch (from, to){
        case (.Empty, .Inserting), (.Inserting, .Loading), (.Loading, .Ready):
            return .Continue
        default:
            return .Abort
        }
    }
}