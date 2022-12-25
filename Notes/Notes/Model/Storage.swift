//
//  Storage.swift
//  Notes
//
//  Created by Artem Alekseev on 21.12.2022.
//

import Foundation

protocol NotesStorageProtocol {
    func getNotes() -> [NotesProtocol]
    func saveNotes(_ notesArray: [NotesProtocol])
}

class NotesStorage: NotesStorageProtocol {
    let userDefaults = UserDefaults.standard
    private var firstLaunch: Bool {
        let wasAlreadyLauched = userDefaults.bool(forKey: "FirstLaunch")
        if wasAlreadyLauched {
           return false
        }
        userDefaults.set(true, forKey: "FirstLaunch")
        return true
    }
    
    func getNotes() -> [NotesProtocol] {
        if firstLaunch {
            return [Note(title: "Demo note. Edit or delete it")]
        }
        var storedArrayOfNotes: [NotesProtocol] = []
        let titleArrayFromStorage = userDefaults.array(forKey: "Notes") as? [String] ?? []
        titleArrayFromStorage.forEach { title in
            storedArrayOfNotes.append(Note(title: title))
        }
        return storedArrayOfNotes
    }
    
    func saveNotes(_ notesArray: [NotesProtocol]) {
        var titleArrayToStorage: [String] = []
        notesArray.forEach { note in
            titleArrayToStorage.append(note.title)
        }
        userDefaults.set(titleArrayToStorage, forKey: "Notes")
    }
}
