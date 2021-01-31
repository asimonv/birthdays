//
//  ComposerViewController.swift
//  Birthdays
//
//  Created by Andre Simon on 18-01-21.
//

import UIKit

class ComposerViewController: UIViewController {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var remindMeTextField: UITextField!
    
    let reminderOptions: [ScheduleReminder] = [.sameDay, .dayBefore, .weekBefore, .monthBefore, .never]
    var selectedReminderOption: ScheduleReminder = .never
    
    weak var birthdayDelegate: BirthdayDelegate?
    
    override func viewDidLoad() {
        remindMeTextField.delegate = self
        
        doneButton.addTarget(self, action: #selector(onPressDone), for: .touchUpInside)
        createPickerView()
        dismissPickerView()
    }
    
    @objc func onPressDone(sender: UIButton) {
        let personName = nameTextField.text ?? ""
        let birthdayDate = datePicker.date
        let birthday = Birthday(person: personName, date: birthdayDate, scheduleReminder: self.selectedReminderOption)
        birthdayDelegate?.newBirthdayAdded(birthday)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func createPickerView () {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        remindMeTextField.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        remindMeTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
       view.endEditing(true)
    }
    
}

extension ComposerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reminderOptions[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedReminderOption = reminderOptions[row]
        remindMeTextField.text = selectedReminderOption.rawValue
    }
}

extension ComposerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        reminderOptions.count
    }
}

extension ComposerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == remindMeTextField {
            return false
        }
        return true
    }
}
