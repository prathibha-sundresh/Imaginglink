//
//  PageViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/19/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "page1"),
            self.getViewController(withIdentifier: "page2"),
            self.getViewController(withIdentifier: "page3")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard(name: "Publishing", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate   = self
        
        if let firstVC = pages[1] as? UIViewController
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        for subview in self.view.subviews {
            if let scrollView = subview as? UIScrollView {
                //scrollView.alwaysBounceHorizontal = false
                scrollView.bounces = false
                break;
            }
        }
        
    }
}

extension PageViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //return nil
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return nil }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        //return nil
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        guard pages.count > nextIndex else { return nil         }
        
        return pages[nextIndex]
    }
}

extension PageViewController: UIPageViewControllerDelegate { }
