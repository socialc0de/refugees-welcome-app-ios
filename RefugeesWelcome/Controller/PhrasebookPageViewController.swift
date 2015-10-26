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
    var sectionSelector: UICollectionView?
    var currentSectionIndex = 0
    var currentTableViewController: PhrasebookTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let tableView = contentAtIndex(0) {
            setViewControllers([tableView], direction: .Forward, animated: false, completion: nil)
        }
    }
    
    func update() {
        if let phrasebook = phrasebook {
            currentTableViewController?.phrasebook = phrasebook
        }
        currentTableViewController?.buildOrUpdatePhraseList()
    }
    
    func goToSection(sectionIndex: Int) {
        if sectionIndex == currentSectionIndex {
            return
        }
        if let tableView = contentAtIndex(sectionIndex) {
            var direction: UIPageViewControllerNavigationDirection!
            if sectionIndex < currentSectionIndex {
                direction = .Reverse
            } else {
                direction = .Forward
            }
            setViewControllers([tableView], direction: direction, animated: true, completion: nil)
            self.currentSectionIndex = sectionIndex
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func contentAtIndex(index: Int) -> PhrasebookTableViewController? {
        var numberOfSections = sectionSelector?.numberOfItemsInSection(0)
        if numberOfSections == nil {
            numberOfSections = 1
        }
        
        if index < 0 || index >= numberOfSections {
            return nil
        }

        let tableViewController = storyboard?.instantiateViewControllerWithIdentifier("PhrasebookTableViewController") as! PhrasebookTableViewController
        tableViewController.sectionIndex = index
        if let phrasebook = phrasebook {
            tableViewController.phrasebook = phrasebook
        }
        
        currentTableViewController = tableViewController
        
        return tableViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return contentAtIndex(currentSectionIndex - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return contentAtIndex(currentSectionIndex + 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        if let index = (pendingViewControllers[0] as? PhrasebookTableViewController)?.sectionIndex {
            currentSectionIndex = index
            if let sectionSelector = sectionSelector {
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                sectionSelector.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
                sectionSelector.reloadSections(NSIndexSet(index: 0))
            }
        }
    }
}
