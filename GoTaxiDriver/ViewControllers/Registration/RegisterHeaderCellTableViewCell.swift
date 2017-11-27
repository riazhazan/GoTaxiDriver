//
//  RegisterHeaderCellTableViewCell.swift
//  GoTaxiDriver
//
//  Created by Riaz on 25/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class RegisterHeaderCellTableViewCell: UITableViewCell, UIPageViewControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var controllerFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    @IBOutlet weak var pageControl: UIPageControl!
    var icon:[String] = ["", "", ""]
    var header:[String] = ["Make as much as you want", "Set your own schedule", "Safety behind the wheel"];
    var subHeader:[String] = ["You decide how many hours you want to work", "Set your own schedule", "GoTaxi is dedicated to keeping people safe on the road."]
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        controllerFrame.size.width = self.bounds.width
        configurePageControl(withWidth: controllerFrame.size.width)
    }
    func configurePageControl(withWidth:CGFloat) {

        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black

        scrollView.delegate = self as? UIScrollViewDelegate
        for index in 0..<3 {
            
            controllerFrame.origin.x = controllerFrame.size.width * CGFloat(index)
            controllerFrame.size.height = self.scrollView.frame.height
            controllerFrame.size.width =  controllerFrame.size.width
            let headerView = HeaderView(frame: controllerFrame)
            headerView.backgroundColor = UIColor.white
            headerView.icon?.backgroundColor = UIColor.lightGray
            headerView.headerLbl?.text = header[index]
            headerView.subHeaderLbl?.text = subHeader[index]
            self.scrollView .addSubview(headerView)
        }
        self.scrollView.isPagingEnabled = true
        self.scrollView.contentSize = CGSize(width: self.bounds.width * 3, height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)

    }
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}

class HeaderView:UIView {
    var icon:UIImageView?
    var headerLbl:UILabel?
    var subHeaderLbl:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        icon = UIImageView()
        icon?.frame = CGRect(x: self.center.x - 35, y: 10, width: 70, height: 70)
        icon?.backgroundColor = UIColor.gray
        headerLbl = UILabel()
        headerLbl?.frame = CGRect(x: 20, y: 80, width: self.frame.size.width - 40, height: 40)
        subHeaderLbl = UILabel()
        subHeaderLbl?.frame = CGRect(x: 20, y: 120, width: self.frame.size.width - 40, height: 30)
        headerLbl?.textAlignment = NSTextAlignment.center
        subHeaderLbl?.textAlignment = NSTextAlignment.center
        headerLbl?.font = UIFont(name: AppRegularFont, size: AppFontBigSize)!
        subHeaderLbl?.font = UIFont(name: AppRegularFont, size: AppFontRegularSize)!
        self.addSubview(icon!)
        self.addSubview(headerLbl!)
        self.addSubview(subHeaderLbl!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

