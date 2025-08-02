//
//  Presenterable.swift
//  PDFReport
//
//  Created by Divyanshu Jadon on 02/08/25.
//

import Foundation

protocol Presenterable {
    
    associatedtype I: Interactorable
    associatedtype R: Routerable
    var dependencies: (interactor: I, router: R) { get }
}
