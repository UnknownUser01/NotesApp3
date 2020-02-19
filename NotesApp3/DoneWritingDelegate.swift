//
//  DoneWritingDelegate.swift
//  NotesApp3
//
//  Created by Rahul Oliver on 04/02/20.
//  Copyright © 2020 Rahul Oliver. All rights reserved.
//

import Foundation

protocol DoneWritingDelegate {
    func doneWriting(title: String?, notes: String?)
    func deselectTable()
}
