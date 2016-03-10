//
//  ConcatViewController.swift
//  ConcatStateMachine
//
//  Created by Daniel Farrell on 27/02/2016.
//  Copyright © 2016 ExcitonLabs. All rights reserved.
//

import Cocoa

/* The view controller is responsible to evolving the state. */
class ConcatViewController: NSViewController, StateMachineDelegate {

    // MARK: Outlets & Properties
    var model = ImportedFileItems()
    
    @IBOutlet weak var tableView: NSTableView!
    
    typealias StateType = ConcatState

    let machine: StateMachine<ConcatViewController>
    
    @IBOutlet weak var exportPDFButton: NSButton!
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    // MARK: Init & Loading
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.machine = StateMachine(initialState: .Empty)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.machine.delegate = self
    }

    required init?(coder: NSCoder) {
        self.machine = StateMachine(initialState: .Empty)
        super.init(coder: coder)
        self.machine.delegate = self
    }
    
    // Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.setDelegate(self.model)
        self.tableView.setDataSource(self.model)

        // Set view to have state consistent with 
        // being in the empty state
        self.exportPDFButton.enabled = false
        self.progressIndicator.hidden = true
    }
    
    // MARK: State machine delegate
    
    // Will transition handles update to the model
    func willTransitionFrom(from: StateType, to: StateType) {
        switch (from, to) {
        case (.Empty, .Inserting(let items, _)):
            // Update model (ignore indexes)
            self.model.items.appendContentsOf(items)
            
        case (.Inserting, .Loading):
            // Update UI
            self.progressIndicator.hidden = false
            self.progressIndicator.startAnimation(nil)
            
        default:
            ()
        }
    }
    
    // Did transition handles updates to the UI
    func didTransitionFrom(from: StateType, to: StateType) {
        
        switch (from, to) {
        case (.Empty, .Inserting(_, _)):
            // State has changed and items have been inserted into the
            // model object. In here we update the user interface.
            self.tableView.reloadData()
        
        case (.Inserting, .Loading(let completionHandler)):
            
            let qualityOfServiceClass = QOS_CLASS_USER_INITIATED
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(backgroundQueue, { [weak self] () -> Void in
                
                if let weakSelf = self {
                    for item in weakSelf.model.items {
                        // Computationally intensive tasks go here
                        item.loadFileURL()
                    }
                }
                
                // Call completion handler always
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Executed on main thread
                    completionHandler()
                })
            })
            
        
        case (.Loading, .Ready):
            // Update UI
            self.progressIndicator.hidden = true
            self.progressIndicator.stopAnimation(nil)
            self.exportPDFButton.enabled = true
            
            
        default:
            ()
        }
    }
    
    // MARK: State transitions
    
    func insertItems(items: [FileItem], at index:NSIndexSet?) {
        // 1. Transition to inserting
        machine.state = .Inserting(items, nil)
        // 2. Automatically transition to loading
        self.transitionToLoading()
    }
    
    func transitionToLoading() {
        
        let completionHandler = { [weak self] () -> Void in
            if let weakSelf = self {
                // When loading to complete transitions to .Ready
                weakSelf.transitionToReady()
            }
        }
        machine.state = .Loading(completionHandler)
    }
    
    func transitionToReady() {
        machine.state = .Ready
    }
    
    // MARK: Repsonder Chain
    @IBAction func exportPDF(sender: AnyObject) {
        Swift.print("exportPDF()")
    }
    
    @IBAction func delete(sender: AnyObject) {
        Swift.print("delete()")
    }
    
    @IBAction func deleteAll(sender: AnyObject) {
        Swift.print("deleteAll()")
    }
    
    @IBAction func importFiles(sender: AnyObject) {
        Swift.print("importFiles()")
        // Make up some fake URLs to import 
        // can cause a state transition
        let newURLs = [NSURL(fileURLWithPath: "MyImageFile.png"), NSURL(fileURLWithPath: "MyDocument.pdf")]
        let newItems = newURLs.map { (url) -> FileItem in
            return FileItem(fileURL: url)
        }
        self.insertItems(newItems, at: nil)
    }
    
}
