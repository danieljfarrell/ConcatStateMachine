import Foundation


protocol StateMachineDelegate: class{
  typealias StateType:StateMachineDataSource
  func willTransitionFrom(from:StateType, to:StateType)
  func didTransitionFrom(from:StateType, to:StateType)
}


protocol StateMachineDataSource{
  func shouldTransitionFrom(from:Self, to:Self)->Should<Self>
}


enum Should<T> {
  case Continue, Abort, Redirect(T)
}

class StateMachine<P:StateMachineDelegate> {
  private var _state:P.StateType{
    willSet{
        delegate?.willTransitionFrom(_state, to: newValue)
    }
    didSet{
      delegate?.didTransitionFrom(oldValue, to: _state)
    }
  }

  var delegate: P?

  var state:P.StateType{
    get{
      return _state
    }
    set{ //Can't be an observer because we need the option to CONDITIONALLY set state
      switch _state.shouldTransitionFrom(_state, to:newValue){
      case .Continue:
        _state = newValue
        
      case .Redirect(let redirectState):
        _state = newValue
        self.state = redirectState

      case .Abort:
        break;
      }
    }
  }
  
  init(initialState:P.StateType, delegate:P){
    _state = initialState //set the primitive to avoid calling the delegate.
    self.delegate = delegate
  }

    init(initialState:P.StateType) {
        _state = initialState
        delegate = nil
    }
}
