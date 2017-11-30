//
//  LoginViewController.swift
//  GoTaxi
//
//  Created by Riaz on 21/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var signInBtnTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var countryInfoLbl: UILabel!
    @IBOutlet var mobileinfoLabel: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var otpTxtField: UITextField!
    @IBOutlet weak var otpInfoLbl: UILabel!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var mobileNoTxtField: UITextField!
    
    var countryPicker:UIPickerView?
    var stepsCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileNoTxtField.becomeFirstResponder()
        configureUIElements()
    }

    func configureUIElements() {
        self.title = NSLocalizedString("SIGNIN", comment: "")
        hideOTPFields(hide: true)
        self.configureTextFieldBorder(textField: mobileNoTxtField)
        self.configureTextFieldBorder(textField: otpTxtField)
        self.configureTextFieldBorder(textField: countryTxtField)
        self.mobileNoTxtField.setPaddingtoTextField(direction: .left)
        self.otpTxtField.setPaddingtoTextField(direction: .left)
        self.countryTxtField.setPaddingtoTextField(direction: .left)
    }
    
    func hideOTPFields(hide: Bool) {
        otpInfoLbl.isHidden = hide
        otpTxtField.isHidden = hide
        signInBtnTopConstrain.constant = 113
        if hide {
            signInBtn.setTitle(NSLocalizedString("NEXT", comment: ""), for: .normal)
            signInBtnTopConstrain.constant = 30
        }else {
            signInBtn.setTitle(NSLocalizedString("SIGNIN", comment: ""), for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInBtnAction(_ sender: Any) {
        
        guard !(mobileNoTxtField.text?.isEmpty ?? true)! else {
            self.showAlertWithTitle("", message: "Please enter your mobile number", OKButtonTitle: "OK", OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
            return
        }
        
        guard !(countryTxtField.text?.isEmpty ?? true)! else {
            self.showAlertWithTitle("", message: "Please select your country", OKButtonTitle: "OK", OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
            return
        }
        
        if stepsCount == 0 {
            self.validatePhoneNumber()
            return
        }
        
        guard !(otpTxtField.text?.isEmpty ?? true)! else {
            self.showAlertWithTitle("", message: "Please enter the recived OTP", OKButtonTitle: "OK", OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
            return
        }
        self.validateOTP()
    }

    func validatePhoneNumber() {
        
        let parameters: [String : Any] = ["CountryID" : 200, "Number": mobileNoTxtField.text!, "UserType": userEntityCode]
        self.showActivityIndicator()
        NetworkManager.validateNumberByRequestingOTP(parameter: parameters) { (status, response) in
            self.removeActivityIndicator()
            if response?.statusCode == APIStatusCodes.OperationSuccess {
                self.stepsCount = 1
                self.hideOTPFields(hide: false)
                return
            }
            self.showAlertWithTitle("", message: response?.statusMessage ?? "Failed to verify your mobile number", OKButtonTitle: "OK", OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
        }
    }
    
    func validateOTP() {
        let parameters:[String : Any] = ["CountryID": 200, "Number": mobileNoTxtField.text!, "UserType": userEntityCode, "OTP": otpTxtField.text!]
        self.showActivityIndicator()
        NetworkManager.validateOTP(parameter: parameters) { (status, response) in
            self.removeActivityIndicator()
            if response?.statusCode == APIStatusCodes.OperationSuccess {
                UserDefaults.standard.set(String(format: "%@", response?.token ?? ""), forKey: DefaultKeys.accessToken)
                self.navigateToNextScreen(isexistingUser: (response?.isExistingUser ?? false)!)
                return
            }
            self.showAlertWithTitle("", message: response?.statusMessage ?? "Failed to verify the OTP", OKButtonTitle: "OK", OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
        }
    }
    
    func navigateToNextScreen(isexistingUser: Bool) {
        if isexistingUser {
            let tabController = TabViewController()
            UIApplication.shared.keyWindow?.rootViewController = tabController
            return
        }
        
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController")
        
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryTxtField {
            self.configureTypePicker(forTextField: textField)
        } else if textField == mobileNoTxtField {
            self.stepsCount = 0
            self.hideOTPFields(hide: true)
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let enteredString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
        if string == "\n" {
            return false
        }
        if enteredString.characters.count > 50 {
            return false
        }
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == countryTxtField {
            
            return
        }
    }
}

extension LoginViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func configureTypePicker(forTextField: UITextField) {
        self.countryPicker = UIPickerView()
        self.countryPicker?.dataSource = self
        self.countryPicker?.delegate = self
        self.countryPicker?.backgroundColor = UIColor.clear
        forTextField.inputView = self.countryPicker
    }
    
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
        countryTxtField.text = self.countriesInEnglish[row]
    }
}
