//
//  UploadDocumentsViewController.swift
//  GoTaxiDriver
//
//  Created by Riaz on 23/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class UploadDocumentsViewController: BaseViewController {

    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var docsTableView: UITableView!
    var docsDataSource: DocumentList?
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: DefaultKeys.isUserLoggedIn)
        configureNavBar()
        self.docsTableView.tableFooterView = UIView()
        self.title = NSLocalizedString("DOCUMENTS", comment: "")
        self.getrequiredDocumentsList()
    }
    
    func configureNavBar() {
        
        let signOutBtn = UIBarButtonItem(title: NSLocalizedString("SIGN_OUT", comment:""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(signOutBtnAction))
        self.navigationItem.leftBarButtonItem = signOutBtn
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: AppMediumFont, size: AppFontRegularSize)!], for: UIControlState.normal)

    }
    
    @objc func signOutBtnAction() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.uploadDocumentToServer()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        for docObj in SharedObjects.sharedInstance.documents ?? [] {
            if !docObj.uploadStatus {
                self.showAlertWithTitle("", message: NSLocalizedString("DOCUMENTS_MISSING", comment: ""), OKButtonTitle: NSLocalizedString("OK", comment: ""), OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
                return
            }
        }
        
        UserDefaults.standard.set(true, forKey: DefaultKeys.isUserLoggedIn)
        let tabController = TabViewController()
        UIApplication.shared.keyWindow?.rootViewController = tabController
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UploadDocumentsViewController {
    func getrequiredDocumentsList() {
        self.showActivityIndicator()
        NetworkManager.getDocumentList(parameter: [:]) { (status, response) in
            self.removeActivityIndicator()
            if response?.statusCode == APIStatusCodes.OperationSuccess {
                self.docsDataSource = response
                SharedObjects.sharedInstance.documents = response?.documents
                self.docsTableView.reloadData()
                return
            }
            self.showAlertWithTitle("", message: NSLocalizedString("GET_DOCS_LIST_FAILED", comment: ""), OKButtonTitle: NSLocalizedString("OK", comment: ""), OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
        }
    }
    
    func uploadDocumentToServer() {
        if SharedObjects.sharedInstance.documentSelectedToUpdate?.image == nil {
            return
        }
        NetworkManager.uploadDocumentToServer(documentId: (SharedObjects.sharedInstance.documentSelectedToUpdate?.documentId)!, selectedImage: (SharedObjects.sharedInstance.documentSelectedToUpdate?.image)!){ (status, response) in
            self.removeActivityIndicator()
            if response?.statusCode == APIStatusCodes.OperationSuccess {
                self.updateUploadStatusOfObject(document: SharedObjects.sharedInstance.documentSelectedToUpdate!)
                SharedObjects.sharedInstance.documentSelectedToUpdate?.image = nil
                self.docsTableView.reloadData()
                return
            }
            self.showAlertWithTitle("", message: NSLocalizedString("UPLOAD_FAILED", comment: ""), OKButtonTitle: NSLocalizedString("OK", comment: ""), OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
        }
    }
    
    func updateUploadStatusOfObject(document: Document) {
        for docObj in SharedObjects.sharedInstance.documents ?? [] {
            if docObj.documentId == document.documentId {
                docObj.uploadStatus = true
            }
        }
    }
}

extension UploadDocumentsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  docsDataSource?.documents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentsTableCell", for: indexPath) as! DocumentsTableCell
        let document = self.docsDataSource?.documents?[indexPath.row]
        cell.documentTitleLbl.text = document?.name
        cell.statusIconImgView.image = UIImage(named: "arrow_gray")
        if document?.documentId == (SharedObjects.sharedInstance.documents?[indexPath.row].documentId ?? -1) && (SharedObjects.sharedInstance.documents?[indexPath.row].uploadStatus ?? false)! {
            cell.statusIconImgView.image = UIImage(named: "tick_gray")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SharedObjects.sharedInstance.documentSelectedToUpdate = self.docsDataSource?.documents?[indexPath.row]
            let uploadVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadViewController")
            self.navigationController?.pushViewController(uploadVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentsHeaderCell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
    }
}
