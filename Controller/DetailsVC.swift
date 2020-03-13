//
//  ViewController.swift
//  PopularMovies
//
//  Created by Marwa Zabara on 3/9/20.
//  Copyright © 2020 Marwa Zabara. All rights reserved.
//

import UIKit
import SDWebImage

class DetailsVC : UIViewController , UITableViewDelegate , UITableViewDataSource{
   
    @IBOutlet weak var PosterImg: UIImageView!
    @IBOutlet weak var TitleTxt: UILabel!
    
    @IBOutlet weak var OverviewTxt: UITextView!
    @IBOutlet weak var YearTxt: UILabel!
 
    @IBOutlet weak var TrailersTable: UITableView!
    var SelectedMovie = Movie(id: "", video: "", release_date: "", original_title: "", poster_Path: "", overview: "", Rate: "")
    //var SelectedMovie : Movie
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TrailersTable.dequeueReusableCell(withIdentifier: "TCell", for: indexPath) as! TrailerCell
        cell.PlayImg.image = UIImage(named: "play.png")
        cell.TrailerTxt.text = "plzz"
       // cell.TrailerTxt.text = "heey"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        TrailersTable.dataSource = self
        TrailersTable.delegate = self
        let ImgURL = BaseURL+Size+SelectedMovie.poster_Path
        TitleTxt.text = SelectedMovie.original_title
        PosterImg?.sd_setImage(with: URL(string: ImgURL), placeholderImage: UIImage(named: "Default3"), options: .highPriority) { (success, Error, cacheType, URL) in
            if let Error = Error {
                print("ERROR DOWNLOADING IMAGE\(Error.localizedDescription) ")
            }
            else {
                print("success")
            }}
        YearTxt.text = SelectedMovie.release_date
        OverviewTxt.text = SelectedMovie.overview
       
    }


}

