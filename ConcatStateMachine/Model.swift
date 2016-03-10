//
//  Model.swift
//  ConcatStateMachine
//
//  Created by Daniel Farrell on 27/02/2016.
//  Copyright © 2016 ExcitonLabs. All rights reserved.
//

import Cocoa

/* A model object that represents a file URL. It has an
additional method for reading the URL data. This is
potentially time consuming so it should be called in
a background thread. */
struct FileItem {
    
    let fileURL: NSURL
    
    let name: String
    
    init(fileURL: NSURL) {
        self.fileURL = fileURL
        if let name = fileURL.lastPathComponent {
            self.name = name
        } else {
            self.name = "Untitled"
        }
    }
    
    func loadFileURL() {
        Swift.print("Creating PDF file from data at URL")
        sleep(2)
    }
}

/* A collection type model objects which just holds many FileItem-s. We implement
NSTableView data source and delegate methods for view creation here. */
class ImportedFileItems: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    var items: [FileItem] = Array()
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeViewWithIdentifier("MAIN_CELL", owner: self) as! NSTableCellView
        cellView.textField!.stringValue = items[row].name
        return cellView
    }
    
}