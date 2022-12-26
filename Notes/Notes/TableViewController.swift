//
//  TableViewController.swift
//  Notes
//
//  Created by Artem Alekseev on 21.12.2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesStorage = NotesStorage()
        notes = notesStorage.getNotes()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // Notes and NotesStorage instances
    var notesStorage: NotesStorageProtocol!
    private var notes: [NotesProtocol] = [] {
        willSet {
            notesStorage.saveNotes(newValue)
        }
    }
    
    // Initialisation of textField text string on EditingViewController, push to EditingViewController. Using closure for data transfer between controllers
    private func prepairForEditScreen(_ text: String, _ handlerClosure: @escaping (String)->Void) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editScreen = storyboard.instantiateViewController(withIdentifier: "editScreen") as! EditingViewController
        editScreen.updatingNoteText = text
        editScreen.completionHandler = handlerClosure
        navigationController?.pushViewController(editScreen, animated: true)
    }
    
    // Creating new note with (+) bar button
    @IBAction func toEditScreen(_ sender: UIBarButtonItem) {
        prepairForEditScreen("") { [unowned self] value in
            notes.insert(Note(title: value), at: 0)
        }
    }
        
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    // Configure custom cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: NoteCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "noteCell") {
            cell = reuseCell as! NoteCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "noteCell") as! NoteCell
        }
        cell.noteTitleLabel.text = notes[indexPath.row].title
        return cell
    }

    // Edit note text by touching note in list.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        prepairForEditScreen(notes[indexPath.row].title) { [unowned self] value in
            notes[indexPath.row].title = value
        }
    }
    
    // Deleting note from list
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Edit notes order in list
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movingNote = notes[fromIndexPath.row]
        notes.remove(at: fromIndexPath.row)
        notes.insert(movingNote, at: to.row)
        tableView.reloadData()
    }
}
