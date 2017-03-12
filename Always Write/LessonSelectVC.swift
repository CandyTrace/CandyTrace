//
//  LessonSelectVC.swift
//  Always Write
//
//  Created by Sam Raudabaugh on 3/12/17.
//  Copyright © 2017 Cornell Tech. All rights reserved.
//

import UIKit

class LessonSelectVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav-pink"), for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Futura-Bold", size: 32)!]
        title = "GUIDED LESSONS"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
