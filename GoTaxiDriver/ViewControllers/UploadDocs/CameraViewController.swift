//
//  CameraViewController.swift
//  GoTaxiDriver
//
//  Created by Riaz on 24/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: BaseViewController {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var flashButton: UIButton!
    var imageCapturedDelegate:DocumentImageCaptureDelegate?
    var captureSession: AVCaptureSession?
    var captureDevice: AVCaptureDevice?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var camShotBtn: UIButton!
    var frontCameraToggled = false
    
    func configureCamShotBtn() {
        camShotBtn.layer.cornerRadius = 40
        camShotBtn.layer.borderWidth = 5
        camShotBtn.clipsToBounds = true
        camShotBtn.layer.borderColor = UIColor().goTaxiBlueColor.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCamShotBtn()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.isStatusBarHidden = true
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .denied {
            let alert = UIAlertController(title: NSLocalizedString("camera_permission_alert_title", comment: "Camera error"), message: NSLocalizedString("camera_permission_alert_description", comment: "We need permission to access the camera. Please go to Settings and enable Camera for this app"), preferredStyle: .alert)
            let closeBtn = UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: { (action) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            let settingsBtn = UIAlertAction(title: NSLocalizedString("settings", comment: "Settings"), style: .default, handler: { (action) -> Void in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil);
//                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            })
            alert.addAction(settingsBtn)
            alert.addAction(closeBtn)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.flashButton.isHidden = false
            
            captureSession = AVCaptureSession()
            
            self.captureDevice = AVCaptureDevice.default(for:AVMediaType.video)
            
            var error: NSError?
            var input: AVCaptureDeviceInput!
            do {
                input = try AVCaptureDeviceInput(device: self.captureDevice!)
            } catch let error1 as NSError {
                error = error1
                input = nil
            }
            
            if error == nil && captureSession!.canAddInput(input) {
                captureSession!.addInput(input)
                
                stillImageOutput = AVCaptureStillImageOutput()
                stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                if captureSession!.canAddOutput(stillImageOutput!) {
                    captureSession!.addOutput(stillImageOutput!)
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                    previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill//AVLayerVideoGravity.resizeAspectFillAVLayerVideoGravity.resizeAspectFill
                    previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    previewLayer!.frame = previewView.bounds
                    previewView.layer.addSublayer(previewLayer!)
                    captureSession!.startRunning()
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func toggleCamera(_ sender: AnyObject) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .authorized {
            frontCameraToggled = !frontCameraToggled
            if let cSession = self.captureSession {
                let devices = AVCaptureDevice.devices(for: AVMediaType.video)
                cSession.beginConfiguration()
                cSession.removeInput((cSession.inputs.last as? AVCaptureInput)!)
                if frontCameraToggled {
                    self.flashButton.isHidden = true
                    self.captureDevice = devices[1] as? AVCaptureDevice
                } else {
                    self.flashButton.isHidden = false
                    self.captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
                }
                do {
                    let input = try AVCaptureDeviceInput.init(device: self.captureDevice!)
                    if cSession.canAddInput(input) {
                        cSession.addInput(input)
                    } else {
                        debugPrint("Could not add input port to capture session")
                    }
                } catch _ {
                    
                }
                
                cSession.commitConfiguration()
            }
        }
    }
    
    @IBAction func toggleFlash(_ sender: AnyObject) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .authorized {
            if (self.captureDevice!.hasTorch) {
                do {
                    try self.captureDevice!.lockForConfiguration()
                    if (self.captureDevice!.torchMode == AVCaptureDevice.TorchMode.on) {
                        self.captureDevice!.torchMode = AVCaptureDevice.TorchMode.off
                    } else {
                        try self.captureDevice!.setTorchModeOn(level: 1.0)
                    }
                    self.captureDevice!
                        .unlockForConfiguration()
                } catch {
                    debugPrint(error)
                }
            }
        }
    }
    
    
    //MARK: Navigation
    
    @IBAction func capturePictureButtonPressed(_ sender: AnyObject) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .authorized {
            if let videoConnection = stillImageOutput!.connection(with: AVMediaType.video) {
                videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
                stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                    if (sampleBuffer != nil) {
                        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                        let dataProvider = CGDataProvider(data: imageData as! CFData)
                        let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                        
                        let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                        
                        self.navigationController?.popViewController(animated: false)
                        self.imageCapturedDelegate?.didCompleteCaptureImage(image: image)
                    }
                })
            }
        }
    }
    
    @IBAction func dismissButton(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: false)
    }
}

