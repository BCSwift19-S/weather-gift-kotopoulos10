//
//  PageVC.swift
//  WeatherGift
//
//  Created by Tom Kotopoulos on 3/8/19.
//  Copyright © 2019 Tom Kotopoulos. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {

    
    var locationsArray = [WeatherLocation]()
    var pageControl: UIPageControl!
    var listButton: UIButton!
    var barButtonWidth: CGFloat = 40
    var barButtonHeight: CGFloat = 40
    var currentPageIndex = 0
    var aboutButton: UIButton!
    var aboutButtonSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        let newLocation = WeatherLocation(name: "", coordinates: "")
        locationsArray.append(newLocation)
        loadLocations()
        
        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureListButton()
        configureAboutButton()
        configurePageControl()
    }
    
    func loadLocations(){
        guard let locationsEncoded = UserDefaults.standard.value(forKey: "locationsArray") as? Data else {
            print("ERROR: Couldn't load locationsArray data from UserDefaults")
            return
        }
        let decoder = JSONDecoder()
        if let locationsArray = try? decoder.decode(Array.self, from: locationsEncoded) as [WeatherLocation] {
            self.locationsArray = locationsArray
        }else{
            print("Couldn't decode data from UserDefaults")
        }
    }
    
    //MARK:- Configuration for View
    func configurePageControl(){
        let largestWidth = max(barButtonWidth, aboutButton.frame.width)
        let pageControlHeight: CGFloat = barButtonHeight
        let pageControlWidth: CGFloat = view.frame.width - (largestWidth*2)
        
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
    
    func configureAboutButton(){
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        let aboutButtonText = "About"
        let aboutButtonFont = UIFont.systemFont(ofSize: 15)
        let fontAttributes = [NSAttributedString.Key.font: aboutButtonFont]
        aboutButtonSize = aboutButtonText.size(withAttributes: fontAttributes)
        
        aboutButtonSize.height += 16
        aboutButtonSize.width += 16
        
        aboutButton = UIButton(frame: CGRect(x: 8, y: (safeHeight - 5) - aboutButtonSize.height, width: aboutButtonSize.width, height: aboutButtonSize.height))
        
        aboutButton.setTitle(aboutButtonText, for: .normal)
        aboutButton.setTitleColor(UIColor.darkText, for: .normal)
        aboutButton.titleLabel?.font = aboutButtonFont
        aboutButton.addTarget(self, action: #selector(segueToAboutVC), for: .touchUpInside)
        view.addSubview(aboutButton)
    }
    
    //MARK:- Segue
    @objc func segueToAboutVC(){
        performSegue(withIdentifier: "ToAboutVC", sender: nil)
    }
    
    @objc func segueToLocationVC(){
        performSegue(withIdentifier: "ToListVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentViewController = self.viewControllers?[0] as? DetailVC else {return}
        locationsArray = currentViewController.locationsArray
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
