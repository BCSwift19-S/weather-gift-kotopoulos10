//
//  PageVC.swift
//  WeatherGift
//
//  Created by Tom Kotopoulos on 3/8/19.
//  Copyright © 2019 Tom Kotopoulos. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {

    var locationsArray = ["Chestnut Hill", "Boston", "Easton", "Florida"]
    var pageControl: UIPageControl!
    var listButton: UIButton!
    var barButtonWidth: CGFloat = 44
    var barButtonHeight: CGFloat = 44
    var currentPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)

        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configurePageControl()
        configureListButton()
    }
    
    //MARK:- Configuration for View
    func configurePageControl(){
        let pageControlHeight: CGFloat = barButtonHeight
        let pageControlWidth: CGFloat = view.frame.width - (barButtonWidth*2)
        
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth)/2, y: safeHeight - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPageIndex
        view.addSubview(pageControl)
    }
    
    func configureListButton(){
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        
        listButton = UIButton(frame: CGRect(x: view.frame.width - barButtonWidth, y: safeHeight - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        listButton.setImage(UIImage(named: "listbutton.png"), for: .normal)
        listButton.setImage(UIImage(named: "listbutton-highlighted"), for: .highlighted)
        
        listButton.addTarget(self, action: #selector(segueToLocationVC), for: .touchUpInside)
        view.addSubview(listButton)
    }
    
    //MARK:- Segue
    @objc func segueToLocationVC(){
        performSegue(withIdentifier: "ToListVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToListVC"{
            let destination = segue.destination as! ListVC
            destination.locationsArray = locationsArray
            destination.currentPage = currentPageIndex
        }
    }
    
    @IBAction func unwindFromListVC (sender: UIStoryboardSegue){
        pageControl.currentPage = currentPageIndex
        pageControl.numberOfPages = locationsArray.count
        setViewControllers([createDetailVC(forPage: currentPageIndex)], direction: .forward, animated: false, completion: nil)
    }
    
    //MARK:- Configuration for DetailVC
    func createDetailVC(forPage page: Int) -> DetailVC {
        
        currentPageIndex = min(max(0, page), locationsArray.count-1)
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        detailVC.locationsArray = locationsArray
        detailVC.currentPageIndex = currentPageIndex
        
        return detailVC
    }
}

extension PageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    //AFTER
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC{
            if currentViewController.currentPageIndex < locationsArray.count-1{
                return createDetailVC(forPage: currentViewController.currentPageIndex + 1)
            }
        }
        return nil
    }
    
    //BEFORE
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC{
            if currentViewController.currentPageIndex > 0 {
                return createDetailVC(forPage: currentViewController.currentPageIndex - 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewControler = pageViewController.viewControllers?[0] as? DetailVC {
            pageControl.currentPage = currentViewControler.currentPageIndex
        }
    }
}
