//
//  EditingViewController.swift
//  Notes
//
//  Created by Artem Alekseev on 22.12.2022.
//

import UIKit

class EditingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTextFieldText(with: updatingNoteText)
    }
    
    @IBOutlet var noteTextField: UITextView!
    var updatingNoteText = ""
    
    private func updateTextFieldText(with text: String) {
        noteTextField.text = text
    }
    
    var completionHandler: ((String) -> Void)?
    
    @IBAction func saveNoteChanges(_ sender: UIBarButtonItem) {
        let updatedText = noteTextField.text ?? ""
        completionHandler?(updatedText)
        navigationController?.popViewController(animated: true)
    }
}
