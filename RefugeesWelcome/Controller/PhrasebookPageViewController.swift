//
//  PhrasebookPageViewController.swift
//  RefugeesWelcome
//
//  Created by Manuel Reich on 25/10/15.
//  Copyright © 2015 socialc0de. All rights reserved.
//

import UIKit

class PhrasebookPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var phrasebook: Phrasebook?
    var sectionIndex = 0
    var currentTableViewController: PhrasebookTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let tableView = contentAtIndex(0) {
            setViewControllers([tableView], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
    }
    
    func update() {
        if let phrasebook = phrasebook {
            currentTableViewController?.phrasebook = phrasebook
        }
        currentTableViewController?.buildOrUpdatePhraseList()
    }
    
    func goToSection(sectionIndex: Int) {
        if let tableView = contentAtIndex(sectionIndex) {
            setViewControllers([tableView], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            self.sectionIndex = sectionIndex
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func contentAtIndex(index: Int) -> PhrasebookTableViewController? {
        let tableViewController = storyboard?.instantiateViewControllerWithIdentifier("PhrasebookTableViewController") as! PhrasebookTableViewController
        if let phrasebook = phrasebook {
            tableViewController.phrasebook = phrasebook
        }
        
        currentTableViewController = tableViewController
        
        return tableViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return contentAtIndex(1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return contentAtIndex(1)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 1
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
