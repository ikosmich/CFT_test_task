//
//  Notes.swift
//  Notes
//
//  Created by Artem Alekseev on 21.12.2022.
//

import Foundation

protocol NotesProtocol {
    var title: String { get set }
}

struct Note: NotesProtocol {
    var title: String
}
