//
//  SchedulePageViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 09.08.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class SchedulePageViewController: UIPageViewController {

    // MARK: Members
    
    var gameDays: [String] = []
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // connect dataSource
        dataSource = self
        
        // initiate with default page
        setDefaultPage()

        // load dates of gamedays
        getGamedaysFromFirebase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Helpers
    
    func getGamedaysFromFirebase() {
        // get all gameday dates from firebase database
        FirebaseClient.sharedInstance.registerGamedaysSingleObservation(completionHandler: { (dates) in
            if let dates = dates {
                self.performUIUpdatesOnMain {
                    self.gameDays = dates
                    
                    // load inital page
                    self.setPage(atIndex: self.getClosestGamedayIndex())
                }
            } 
        })
    }
    
    func getScheduleViewController(forPageIndex index: Int) -> ScheduleViewController? {
        guard let storyboard = storyboard, let page = storyboard.instantiateViewController(withIdentifier: "ScheduleViewController") as? ScheduleViewController else {
            return nil
        }
        
        page.pageIndex = index
        page.pageViewController = self
        page.selectedGameDay = gameDays[index]
        
        return page
    }
    
    func setPage(atIndex index: Int, towards: UIPageViewControllerNavigationDirection = .forward, animated: Bool = false) {
        if let viewController = getScheduleViewController(forPageIndex: index) {
            setViewControllers([viewController], direction: towards, animated: animated, completion: nil)
        }
    }
    
    func setDefaultPage() {
        guard let page = storyboard?.instantiateViewController(withIdentifier: "ScheduleDefaultViewController") else {
            return
        }
        setViewControllers([page], direction: .forward, animated: false, completion: nil)
    }
    
    func isAtMaxIndex(_ viewController: UIViewController?) -> Bool {
        if let viewController = viewController as? ScheduleViewController, let index = viewController.pageIndex, (index + 1) < gameDays.count {
            return false
        } else {
            return true
        }
    }
    
    func isAtMinIndex(_ viewController: UIViewController?) -> Bool {
        if let viewController = viewController as? ScheduleViewController, let index = viewController.pageIndex, index > 0 {
            return false
        } else {
            return true
        }
    }
    
    public func showNextPage() {
        // if not max index -> set page index + 1
        if !isAtMaxIndex(viewControllers?[0]) {
            setPage(atIndex: ((viewControllers![0] as! ScheduleViewController).pageIndex + 1), towards: .forward, animated: true)
        }
    }
    
    public func showPrevPage() {
        // if not min index -> set page index - 1
        if !isAtMinIndex(viewControllers?[0]) {
            setPage(atIndex: ((viewControllers![0] as! ScheduleViewController).pageIndex - 1), towards: .reverse, animated: true)
        }
    }
    
    func getClosestGamedayIndex() -> Int {
        // map gamedays dates to integers for comparison
        let gameDaysInt = gameDays.map({ Int($0)! })
        
        // get current date in corresponding format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FirebaseClient.Constants.GameDays.DateFormat
        let dateToday: Int = Int(dateFormatter.string(from: Date()))!
        
        // find closest gameday in array and return its index
        let closest = gameDaysInt.enumerated().min(by: { abs($0.1 - dateToday) <= abs($1.1 - dateToday) })
        if let index = closest?.offset {
            return index
        } else {
            return 0
        }
    }
}


// MARK: PageViewController DataSource delegates

extension SchedulePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // if not max index -> return vc for index + 1
        if !isAtMaxIndex(viewController) {
            return getScheduleViewController(forPageIndex: ((viewController as! ScheduleViewController).pageIndex + 1))
        }
        return nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // if not min index -> return vc for index -1
        if !isAtMinIndex(viewController) {
            return getScheduleViewController(forPageIndex: ((viewController as! ScheduleViewController).pageIndex - 1))
        }
        return nil
    }
}
