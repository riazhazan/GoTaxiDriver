//
//  UploadViewController.swift
//  GoTaxiDriver
//
//  Created by Riaz on 23/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class UploadViewController: BaseViewController {

    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var docImgView: UIImageView!
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var documentNameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI() {
        docImgView.layer.borderWidth = 1
        docImgView.layer.borderColor = UIColor.lightGray.cgColor
        self.title = NSLocalizedString("DOCUMENTS", comment: "")
        takePhotoBtn.setTitle(NSLocalizedString("TAKE_PHOTO", comment: ""), for: .normal)
        instructionLbl.text = NSLocalizedString("UPLOAD_DOC", comment: "")
    }
    
    @IBAction func takePhotoBtnAction(_ sender: Any) {
        let camVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController
        camVC?.imageCapturedDelegate = self
        self.navigationController?.pushViewController(camVC!, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
extension UploadViewController: DocumentImageCaptureDelegate {
    func didCompleteCaptureImage(image: UIImage) {
        let previewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController
        previewVC?.capturedImage = image
        self.navigationController?.pushViewController(previewVC!, animated: false)
    }
}

protocol DocumentImageCaptureDelegate {
    func didCompleteCaptureImage(image: UIImage)
}
