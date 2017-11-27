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
    case city
    case inviteCode
    case registerButton
    case lastName
    case phoneNumber
    case password
    case country
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
        
        
        if (requestModel.password?.characters.count ?? 0)! < 6 {
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
        
        return  isUserNameAvailable ? 5 : 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !isUserNameAvailable {
            return 50
        }
        
        if indexPath.row == 1 {
         return 150
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !isUserNameAvailable {
            if indexPath.row == 1 {
                return configureRegisterBtnCell(tableView, indexPath: indexPath)
            } else {
                return configureRegistrationDetailsCell(tableView, indexPath: indexPath)
            }
        } else {
            if indexPath.row == RegistrationFormRow.registerButton.rawValue {
                return configureRegisterBtnCell(tableView, indexPath: indexPath)
            } else {
                return configureRegistrationDetailsCell(tableView, indexPath: indexPath)
            }
        }

    }
    func configureRegistrationDetailsCell(_ tableView:UITableView, indexPath: IndexPath) -> UITableViewCell{
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicDetailsTableCell", for: indexPath) as! BasicDetailsTableCell
            self.configureBasicDetailsCell(cell: cell, indexPath: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationTableCell", for: indexPath) as! RegistrationTableCell
        cell.inputTxtField.delegate = self
        cell.inputTxtField.text = ""
        
        if indexPath.row == 0 {
            cell.inputTxtField.tag = RegistrationFormRow.userName.rawValue
            cell.inputTxtField.becomeFirstResponder()
            cell.inputTxtField.text = requestModel.userName
        } else if indexPath.row == 2 {
            cell.inputTxtField.tag = RegistrationFormRow.city.rawValue
            cell.inputTxtField.text = requestModel.city
        } else if indexPath.row == 3 {
            cell.inputTxtField.tag = RegistrationFormRow.inviteCode.rawValue
            cell.inputTxtField.text = requestModel.inviteCode
        }
        return cell
    }
    
    func configureBasicDetailsCell(cell: BasicDetailsTableCell, indexPath: IndexPath) {
        cell.firstNameTxtField.tag = RegistrationFormRow.firstName.rawValue
        cell.firstNameTxtField.text = requestModel.firstName
        cell.lastNameTxtField.tag = RegistrationFormRow.lastName.rawValue
        cell.lastNameTxtField.text = requestModel.lastName
        cell.phoneTxtField.tag = RegistrationFormRow.phoneNumber.rawValue
        cell.phoneTxtField.text = requestModel.phone
        cell.passwordTxtField.tag = RegistrationFormRow.password.rawValue
        cell.passwordTxtField.text = requestModel.password
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterHeaderCellTableViewCell") as? RegisterHeaderCellTableViewCell
       cell?.configurePageControl(withWidth: (cell?.frame.size.width)!)
        cell?.layoutIfNeeded()
        
        cell?.contentView.bringSubview(toFront:(cell?.pageControl)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
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
