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
    var isUserNameAvailable: Bool = false
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
        if !isUserNameAvailable {
            if (requestModel.userName?.isEmpty ?? true)!{
               self.showAlertWithTitle("", message: "Please eneter a username", OKButtonTitle: "OK", OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
                return
            }
            self.validateuserNameAvailablilty(userName: requestModel.userName!)
            return
        }
        
        if (requestModel.userName?.isEmpty ?? true)! || (requestModel.firstName?.isEmpty  ?? true)! || (requestModel.lastName?.isEmpty ?? true)! || (requestModel.country?.isEmpty ?? true)! || (requestModel.phone?.isEmpty ?? true)! || (requestModel.password?.isEmpty ?? true)! || (requestModel.confirmPassword?.isEmpty ?? true)! {
            self.showAlertWithTitle("", message: "All fields are mandatory for registration. Please try again.", OKButtonTitle: "OK", OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
            return
        }
        
        
        if requestModel.password  != requestModel.confirmPassword {
            self.showAlertWithTitle("", message: "Password and confirm password does not match", OKButtonTitle: "OK", OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
            return
        }
        self.registerDriverInServer()
    }
}

extension RegistrationViewController {
    func validateuserNameAvailablilty(userName: String) {
        self.showActivityIndicator()
        NetworkManager.validateUserName(userName: userName){ (status, response) in
            self.removeAllActivityIndicators()
            if response?.statusCode == APIStatusCodes.OperationSuccess  && (response?.isAvailable ?? false)! {
                self.isUserNameAvailable = response?.isAvailable ?? true
                self.registrationTableView.reloadData()
                return
            }
            self.isUserNameAvailable = false
            self.showAlertWithTitle("", message: "This username is already taken. Please try some other.", OKButtonTitle: "OK", OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
        }
    }
    
    func registerDriverInServer() {
        
        let parameters:[String : Any] = requestModel.formatInputDictionary()
        self.showActivityIndicator()
        NetworkManager.registerDriver(parameter: parameters) { (status, response) in
            self.removeActivityIndicator()
            if response?.statusCode == APIStatusCodes.OperationSuccess  {
                self.navigateToDocumentUploadScreen()
                return
            }
            self.showAlertWithTitle("", message: response?.statusMessage ?? "Failed to register driver. Please try again.", OKButtonTitle: "OK", OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
        }
    }
    
    func navigateToDocumentUploadScreen() {
        let docsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadDocumentsViewController")
        self.navigationController?.pushViewController(docsVC, animated: true)
    }
}

extension RegistrationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  isUserNameAvailable ? 8 : 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !isUserNameAvailable {
            if indexPath.row == 1 {
                return configureRegisterBtnCell(tableView, indexPath: indexPath)
            } else {
                return configureBasicProfileDetailCell(tableView, indexPath: indexPath)
            }
        } else {
            if indexPath.row == RegistrationFormRow.registerButton.rawValue {
                return configureRegisterBtnCell(tableView, indexPath: indexPath)
            } else {
                return configureBasicProfileDetailCell(tableView, indexPath: indexPath)
            }
        }
        
        
        
    }
    func configureBasicProfileDetailCell(_ tableView:UITableView, indexPath: IndexPath) -> RegistrationTableCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationTableCell", for: indexPath) as! RegistrationTableCell
        cell.inputTxtField.tag = indexPath.row
        cell.inputTxtField.delegate = self
        cell.inputTxtField.attributedPlaceholder = setPlaceHolderString(placeholderStr: registartionPlaceholders[indexPath.row])
        cell.inputTxtField.text = ""
        cell.inputTxtField.keyboardType = .default
        cell.inputTxtField.isSecureTextEntry = false
        
        switch indexPath.row {
        case RegistrationFormRow.userName.rawValue:
            cell.inputTxtField.becomeFirstResponder()
            cell.inputTxtField.text = requestModel.userName
        case RegistrationFormRow.firstName.rawValue:
            cell.inputTxtField.text = requestModel.firstName
        case RegistrationFormRow.lastName.rawValue:
            cell.inputTxtField.text = requestModel.lastName
        case RegistrationFormRow.country.rawValue:
            cell.inputTxtField.text = requestModel.country
        case RegistrationFormRow.phoneNumber.rawValue:
            cell.inputTxtField.keyboardType = .phonePad
            cell.inputTxtField.text = requestModel.phone
        case RegistrationFormRow.password.rawValue:
            cell.inputTxtField.isSecureTextEntry = true
            cell.inputTxtField.text = requestModel.password
        case RegistrationFormRow.confirmPassword.rawValue:
            cell.inputTxtField.isSecureTextEntry = true
            cell.inputTxtField.text = requestModel.confirmPassword
        default:
            break
        }
        return cell
    }
    
    func configureRegisterBtnCell(_ tableView:UITableView, indexPath: IndexPath) -> ActionButtonTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionButtonTableCell", for: indexPath) as! ActionButtonTableCell
        cell.actionBtn.addTarget(self, action: #selector(signupBtnAction), for: .touchUpInside)
        cell.actionBtn.setTitle(NSLocalizedString("REGISTER", comment: ""), for: .normal)
        
        if !isUserNameAvailable {
            cell.actionBtn.setTitle(NSLocalizedString("NEXT", comment: ""), for: .normal)
        }
        
        
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
            break
        }
        

        if enteredString.characters.count > 50 {
                return false
            }
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == RegistrationFormRow.country.rawValue {
            self.registrationTableView.reloadRows(at: [IndexPath(row: textField.tag, section: 0)], with: UITableViewRowAnimation.automatic)
        }
//        if textField.tag == RegistrationFormRow.userName.rawValue && !(textField.text?.isEmpty ?? true)! {
//            self.validateuserNameAvailablilty(userName: requestModel.userName ?? "")
//        }
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
        requestModel.countryCode = 200
    }
}
