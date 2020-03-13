//
//  ViewController.swift
//  PopularMoviesProject
//
//  Created by Marwa Zabara on 3/9/20.
//  Copyright © 2020 Marwa Zabara. All rights reserved.
//
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    
    @IBOutlet weak var TrailersTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return 4
            }
    
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = TrailersTable.dequeueReusableCell(withIdentifier: "TCell", for: indexPath) as! TrailerCell
                cell.PlayImg?.image = UIImage(named: "play.png")
                cell.TrailerTxt.text = "heey"
        
        
        //        cell.textLabel?.text = "hiiii"
                return cell
            }
    
            func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 75
            }
    
          
    
            override func viewDidLoad() {
                super.viewDidLoad()
                TrailersTable.dataSource = self
                TrailersTable.delegate = self
                // Do any additional setup after loading the view, typically from a nib.
            }
    
    
}






//func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerCell", for:indexPath) as! TrailerCell
//    print("in dequeue")
//    cell.TrailerTxt?.text = "trailer "
//    cell.PlayImg?.image = UIImage(named: "play.png");
//    return cell
//}
//
//func numberOfSections(in tableView: UITableView) -> Int {
//    print("in number of sections")
//
//    return 1
//}
//
//func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    print("in height")
//
//    return 150
//}

////
////  ViewController.swift
////  PopularMovies
////
////  Created by Marwa Zabara on 3/9/20.
////  Copyright © 2020 Marwa Zabara. All rights reserved.
////
//
//import UIKit
//
//class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = TrailersTable.dequeueReusableCell(withIdentifier: "TCell", for: indexPath) as! TrailerCell
//        cell.PlayImg?.image = UIImage(named: "play.png")
//        cell.TrailerTxt.text = "heey"
//
//
////        cell.textLabel?.text = "hiiii"
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
//
//    @IBOutlet weak var TrailersTable: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        TrailersTable.dataSource = self
//        TrailersTable.delegate = self
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//
//}
//
