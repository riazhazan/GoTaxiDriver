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
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var controllerFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    @IBOutlet weak var pageControl: UIPageControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        //configurePageControl()
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

        self.pageControl.numberOfPages = colors.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green

        
        scrollView.delegate = self as? UIScrollViewDelegate
        for index in 0..<4 {
            
            controllerFrame.origin.x = controllerFrame.size.width * CGFloat(index)
            controllerFrame.size.height = self.scrollView.frame.height
            controllerFrame.size.width =  controllerFrame.size.width
            let subView = UIView(frame: controllerFrame)
            subView.backgroundColor = colors[index]
            self.scrollView .addSubview(subView)
        }
        self.scrollView.isPagingEnabled = true
        self.scrollView.contentSize = CGSize(width: self.bounds.width * 4, height: self.scrollView.frame.size.height)
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

    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        <#code#>
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        <#code#>
//    }
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return 3
//    }
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
}
