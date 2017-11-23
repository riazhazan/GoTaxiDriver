import Foundation
import UIKit

// MARK: - UIViewCOntroller extension
extension UIViewController {
    
    /// Defines associatedkeys for storing properties in estension
    private struct AssociatedKey {
        static var indicatorCountKey:   UInt8 = 0
        static var indicatorViewKey:   UInt8 = 0
    }
    
    
    /// New property stored in UIView definition
    var indicatorRetainCount: Int? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.indicatorCountKey) as? Int
        }
        
        set(count) {
            objc_setAssociatedObject(self, &AssociatedKey.indicatorCountKey, count, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// New property stored in UIView definition
    var activityOverlayView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.indicatorViewKey) as? UIView
        }
        
        set(indicatorView) {
            objc_setAssociatedObject(self, &AssociatedKey.indicatorViewKey, indicatorView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    /// Sets up a AlertViewController with related completion handlers
    ///
    /// - Parameters:
    ///   - title: Alert title string
    ///   - messageString: Alert message string
    ///   - OKtitle: Title string for Accept button
    ///   - OKcompletion: Completionhandler for Accept button
    ///   - cancelTitle: Title strign for Cancel button
    ///   - cancelCompletion: Completionhandler for Cancel button
    func showAlertWithTitle(_ title: String?,
                            message messageString: String,
                            OKButtonTitle OKtitle: String?,
                            OKcompletion: ((UIAlertAction) -> Void)?,
                            cancelButtonTitle cancelTitle: String?,
                            cancelCompletion: ((UIAlertAction) -> Void)?){
        
        var appViewController = UIApplication.shared.keyWindow!.rootViewController
        
        while appViewController?.presentedViewController != nil {
            appViewController = appViewController?.presentedViewController
        }
        
        let alert = UIAlertController(title: title ?? "",
                                      message: messageString,
                                      preferredStyle: .alert)
        
        if let OKtitle = OKtitle {
            
            alert.addAction(UIAlertAction(title: OKtitle,
                                          style: .default,
                                          handler:
                { (action) in
                    OKcompletion?(action)
            }))
        }
        
        if let cancelTitle = cancelTitle {
            alert.addAction(UIAlertAction(title: cancelTitle,
                                          style: .cancel,
                                          handler:
                { (action) in
                    cancelCompletion?(action)
            }))
        }
        
        DispatchQueue.main.async {
            appViewController?.present(alert,
                                       animated: true,
                                       completion: nil)
        }
    }
    
    
    /// Adds an activity indicator to the UIViewController
    func showActivityIndicator(){
        //initialise the indicatorRetainCount stored property
        if self.indicatorRetainCount == nil {
            self.indicatorRetainCount = 0
        }
        
        self.indicatorRetainCount = (self.indicatorRetainCount ?? 0) + 1 //increment retain count on each call to activity indicator
        if (self.indicatorRetainCount ?? 0) <= 1 && self.activityOverlayView == nil {
            //activity indicator is added if it is not added already
            DispatchQueue.main.async {
                self.addActivityIndicator()
            }
        }
    }
    
    
    /// Add the activity indicator
    private func addActivityIndicator() {
        var heightRatio: CGFloat = 1.0 //heightRatio for iPad
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            if UIApplication.shared.statusBarOrientation.isPortrait {
                heightRatio = UIScreen.main.bounds.width / 414
            }
            else {
                heightRatio = UIScreen.main.bounds.height / 414
            }
        default:
            break
        }
        
        let window = UIApplication.shared.delegate?.window!!
        let baseLineView = window!.forFirstBaselineLayout
        
        self.activityOverlayView = UIView()
        activityOverlayView?.translatesAutoresizingMaskIntoConstraints = false
        activityOverlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        baseLineView.addSubview(activityOverlayView!)
        baseLineView.bringSubview(toFront: activityOverlayView!)
        
        let topConstraint = NSLayoutConstraint(item: activityOverlayView!, attribute: .top, relatedBy: .equal, toItem: baseLineView, attribute: .top, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: activityOverlayView!, attribute: .leading, relatedBy: .equal, toItem: baseLineView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: activityOverlayView!, attribute: .trailing, relatedBy: .equal, toItem: baseLineView, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: activityOverlayView!, attribute: .bottom, relatedBy: .equal, toItem: baseLineView, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
        
        let activityView = UIView(frame: CGRect(x: 0, y: 0, width: 73 * heightRatio, height: 73 * heightRatio))
        activityOverlayView?.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: activityOverlayView!, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: activityOverlayView!, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: activityView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 73 * heightRatio)
        let heightConstraint = NSLayoutConstraint(item: activityView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 73 * heightRatio)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityView.addSubview(imageView)
        
        let top = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: activityView, attribute: .top, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: activityView, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: activityView, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: activityView, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
        
        imageView.image = UIImage(named: "activityIndicatorIcon")
        imageView.contentMode = .scaleAspectFit
        
        for layer in activityView.layer.sublayers! {
            if layer.isKind(of: CAShapeLayer.self) {
                layer.removeFromSuperlayer()
            }
        }
        
        var progressCircle = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: /*CGPoint(x: 0, y: 0)*/CGPoint(x: activityView.bounds.midX, y: activityView.bounds.midY), radius: (activityView.bounds.width / 2) - 4, startAngle: 0, endAngle: CGFloat(CGFloat.pi * 2), clockwise: true)
        progressCircle = CAShapeLayer ()
        progressCircle.path = circlePath.cgPath
        progressCircle.strokeColor = UIColor.white.cgColor
        progressCircle.fillColor = UIColor.clear.cgColor
        progressCircle.lineWidth = 8//self.loader.bounds.width / 2
        
        activityView.layer.addSublayer(progressCircle)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 3
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.autoreverses = false
        animation.repeatCount = 50
        
        progressCircle.add(animation, forKey: "customAnimation")
        for subView in activityView.subviews {
            if subView.isKind(of: UIImageView.self) {
                activityView.bringSubview(toFront: subView)
            }
        }
    }
    
    
    /// Reduces the retain count of activity indicator and finally removes it
    func removeActivityIndicator(){
        DispatchQueue.main.async {
            self.indicatorRetainCount = (self.indicatorRetainCount ?? 1) - 1
            if (self.indicatorRetainCount ?? 0) < 1 {
                //remove the activity indicator if no controllers are keeping a reference to it
                self.removeAllActivityIndicators()
            }
        }
    }
    
    
    /// Removes activity indicator from the view
    func removeAllActivityIndicators() {
        DispatchQueue.main.async {
            self.indicatorRetainCount = 0
            self.activityOverlayView?.removeFromSuperview()
            self.activityOverlayView = nil
        }
    }
    
}
