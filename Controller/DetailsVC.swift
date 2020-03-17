//
//  ViewController.swift
//  PopularMovies
//
//  Created by Marwa Zabara on 3/9/20.
//  Copyright © 2020 Marwa Zabara. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
// import YouTubePlayer
import YoutubePlayer_in_WKWebView
import CoreData
import Cosmos



class DetailsVC : UIViewController , UITableViewDelegate , UITableViewDataSource{
    @IBAction func ExitVideoPressed(_ sender: Any) {
        VideoView.isHidden =
        true
    }
    @IBOutlet weak var Rating: CosmosView!
    @IBOutlet weak var FavBtn: UIButton!
  //  @IBOutlet weak var VideoView: YouTubePlayerView!
    @IBOutlet weak var VideoView: WKYTPlayerView!
    
    
    var Trailers: [Trailer] = []
    @IBOutlet weak var PosterImg: UIImageView!
    @IBOutlet weak var TitleTxt: UILabel!
    
    @IBOutlet weak var OverviewTxt: UITextView!
    @IBOutlet weak var YearTxt: UILabel!
 
    @IBOutlet weak var TrailersTable: UITableView!
    var SelectedMovie = Movie(id: "", release_date: "", original_title: "", poster_Path: "", overview: "", Rate: 0.0)
    //var SelectedMovie : Movie
    override func viewWillAppear(_ animated: Bool) {
        Alamofire.request("https://api.themoviedb.org/3/movie/"+SelectedMovie.id+"/videos?api_key=6557d01ac95a807a036e5e9e325bb3f0").responseJSON { (Response) in
            let json = JSON(Response.value)
            json["results"].array?.forEach({ (currentTrailer) in
                let currentTrailer = Trailer(Key: currentTrailer["key"].stringValue, Name: currentTrailer["name"].stringValue)
                self.Trailers.append(currentTrailer)
                print(".....................")
                self.TrailersTable.reloadData()
                
                
            })
        }
    }
    @IBAction func FavPressed(_ sender: Any) {
      // check if exists in favorites
        //add to favorites
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Faves")
        var predicate : NSPredicate = NSPredicate()
        predicate = NSPredicate(format: "name == %@", SelectedMovie.original_title)
        request.predicate = predicate
        // request.returnsObjectsAsFaults = false
        do{
            print("in do")
            let result = try context.fetch(request)
//            for data in result as! [NSManagedObject]{
//                let name = data.value(forKey: "name")
//                print("name= ",name)
//              //  self.Faves.append(currentMovie)
//
//                print("after append")
//              //  self.tableView.reloadData()
//            }
            if (result.isEmpty){
                let entity = NSEntityDescription.entity(forEntityName: "Faves", in: context)
                let newEntity = NSManagedObject(entity: entity!, insertInto: context)
                newEntity.setValue(SelectedMovie.original_title, forKey: "name")
                newEntity.setValue(SelectedMovie.overview, forKey: "overview")
                newEntity.setValue(SelectedMovie.Rate, forKey: "rate")
                newEntity.setValue(SelectedMovie.id, forKey: "id")
                newEntity.setValue(SelectedMovie.release_date, forKey: "date")
                newEntity.setValue(SelectedMovie.poster_Path, forKey: "path")
                do{
                    try context.save()
                    FavBtn.setImage(UIImage(named:"filledHeart"), for: .normal)
                    print("WELL SAVED")
                    
                }
                catch{
                    print("FAILED TO SAVE")
                }
                
            }
        }
        catch{
            print("FETCHING FAILED")
            
            
        }
      

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        InitUI()
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.endVideo))
        //swipe.direction = .up
        swipe.direction = .down
        
        view.addGestureRecognizer(swipe)
       
    }
    @objc func endVideo(){
        VideoView.isHidden = true
    }

    func InitUI() {
    TrailersTable.dataSource = self
    TrailersTable.delegate = self
    self.VideoView.isHidden = true
    Rating.settings.updateOnTouch = false
    Rating.settings.fillMode = .precise



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
        print("rating=",SelectedMovie.Rate)
        Rating.rating = Double(SelectedMovie.Rate/2)
    }
}



extension DetailsVC {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Trailers.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = TrailersTable.dequeueReusableCell(withIdentifier: "TCell", for: indexPath) as! TrailerCell
    cell.PlayImg.image = UIImage(named: "play.png")
    cell.TrailerTxt.text = Trailers[indexPath.row].Name
    print(SelectedMovie.id)
    return cell
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.VideoView.isHidden = false
        self.VideoView.load(withVideoId: Trailers[indexPath.row].Key)

    }
    
    
}
