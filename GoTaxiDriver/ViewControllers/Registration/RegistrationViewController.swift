//
//  RegistrationViewController.swift
//  GoTaxi
//
//  Created by Riaz on 22/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

enum RegistrationFormRow: Int {
    case userName = 0
    case firstName
    case lastName
    case country
    case phoneNumber
    case password
    case confirmPassword
    case registerButton
}

class RegistrationViewController: BaseViewController {
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var subHeaderLbl: UILabel!
    @IBOutlet weak var registrationTableView: UITableView!
    var countryPicker:UIPickerView?
    var requestModel = RegistrationRequest()
    
    var registartionPlaceholders = [NSLocalizedString("USERNAME", comment: ""), NSLocalizedString("FNAME", comment: ""), NSLocalizedString("LNAME", comment: ""), NSLocalizedString("COUNTRY", comment: ""), NSLocalizedString("PHONE", comment: ""), NSLocalizedString("PASSWORD", comment: ""),
        NSLocalizedString("CONFIRM_PASSWORD", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("REGISTER", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func signupBtnAction() {
        
    }
}

extension RegistrationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == RegistrationFormRow.registerButton.rawValue {
            return configureRegisterBtnCell(tableView, indexPath: indexPath)
        } else {
            return configureBasicProfileDetailCell(tableView, indexPath: indexPath)
        }
    }
    func configureBasicProfileDetailCell(_ tableView:UITableView, indexPath: IndexPath) -> RegistrationTableCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationTableCell", for: indexPath) as! RegistrationTableCell
        cell.inputTxtField.tag = indexPath.row
        cell.inputTxtField.delegate = self
        cell.inputTxtField.attributedPlaceholder = setPlaceHolderString(placeholderStr: registartionPlaceholders[indexPath.row])
        return cell
    }
    
    func configureRegisterBtnCell(_ tableView:UITableView, indexPath: IndexPath) -> ActionButtonTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionButtonTableCell", for: indexPath) as! ActionButtonTableCell
        cell.actionBtn.addTarget(self, action: #selector(signupBtnAction), for: .touchUpInside)
        return cell
    }
    
    func configureTypePicker(forTextField: UITextField) {
        self.countryPicker = UIPickerView()
        self.countryPicker?.dataSource = self
        self.countryPicker?.delegate = self
        self.countryPicker?.backgroundColor = UIColor.clear
        forTextField.inputView = self.countryPicker
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == RegistrationFormRow.country.rawValue {
            self.configureTypePicker(forTextField: textField)
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let enteredString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
        if string == "\n" {
            return false
        }
        switch textField.tag {
        case RegistrationFormRow.userName.rawValue:
            requestModel.userName = enteredString
        case RegistrationFormRow.firstName.rawValue:
            requestModel.firstName = enteredString
        case RegistrationFormRow.lastName.rawValue:
            requestModel.lastName = enteredString
        case RegistrationFormRow.country.rawValue:
            requestModel.country = enteredString
        case RegistrationFormRow.phoneNumber.rawValue:
            requestModel.phone = enteredString
        case RegistrationFormRow.password.rawValue:
            requestModel.password = enteredString
        case RegistrationFormRow.confirmPassword.rawValue:
            requestModel.confirmPassword = enteredString
            
        default:
            print("Entered default")
        }

        if enteredString.characters.count > 50 {
                return false
            }
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField.text?.isEmpty)! ||  textField.tag == RegistrationFormRow.country.rawValue {
            if textField.tag == RegistrationFormRow.country.rawValue  {
                self.registrationTableView.reloadRows(at: [IndexPath(row: textField.tag, section: 0)], with: UITableViewRowAnimation.automatic)
            }
            return
        }
    }
}

extension RegistrationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.countriesInEnglish.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countriesInEnglish[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestModel.country = self.countriesInEnglish[row]
        requestModel.countryCode = "200"
    }
}
