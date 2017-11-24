//
//  PreviewViewController.swift
//  GoTaxiDriver
//
//  Created by Riaz on 24/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class PreviewViewController: BaseViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var submitLbl: UILabel!
    @IBOutlet weak var retakeLbl: UILabel!
    @IBOutlet weak var retakeBtn: UIButton!
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var previewImgView: UIImageView!
    var capturedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        previewImgView.image = capturedImage
    }
    
    func configureUI() {
        submitBtn.layer.cornerRadius = 25
        retakeBtn.layer.cornerRadius = 25
        submitBtn.layer.borderWidth = 1
        retakeBtn.layer.borderWidth = 1
        submitBtn.clipsToBounds = true
        retakeBtn.clipsToBounds = true
        submitBtn.layer.borderColor = UIColor().goTaxiBlueColor.cgColor
        retakeBtn.layer.borderColor = UIColor().textFieldBorderColor.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    @IBAction func retakeBtnAction(_ sender: Any) {
        let camVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController
        camVC?.imageCapturedDelegate = self
        self.navigationController?.pushViewController(camVC!, animated: false)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        SharedObjects.sharedInstance.documentSelectedToUpdate?.image = capturedImage
        if let viewControllers = self.navigationController?.viewControllers {
            for (index, element) in viewControllers.enumerated(){
                if element is UploadDocumentsViewController {
                    let _ =  self.navigationController?.popToViewController((self.navigationController?.viewControllers[index])!, animated: true)
                    return
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
}
extension PreviewViewController: DocumentImageCaptureDelegate {
    func didCompleteCaptureImage(image: UIImage) {
        capturedImage = image
        previewImgView.image = capturedImage
    }
}
