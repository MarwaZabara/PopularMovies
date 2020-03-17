//
//  Test.swift
//  PopularMovies
//
//  Created by Marwa Zabara on 3/10/20.
//  Copyright © 2020 Marwa Zabara. All rights reserved.
//https://api.themoviedb.org/3/discover/movie?api_key=6557d01ac95a807a036e5e9e325bb3f0&sort_by=popularity.desc
//https://api.themoviedb.org/3/discover/movie?sort_by=popularity.%20desc&api_key=202ba4844c1bb76fac091315072d3804
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import CoreData
//
//struct Item {
//   var imageName: String
//}
class HomeVC: UIViewController {
    @IBOutlet weak var SortType: UISegmentedControl!
    var Movies: [Movie] = []
    @IBAction func SortChange(_ sender: Any) {
        
  
        let Index = SortType.selectedSegmentIndex
        print(Index)
        switch Index {
        case 0:
            if (SortWith != Rating){
            SortWith = Rating
                Movies.removeAll()
                LoadData()
            }
            
        case 1:
            if (SortWith != Popularity){
            SortWith = Popularity
                Movies.removeAll()
                LoadData()

            }
        default:
            SortWith = Popularity
        }
        
    }
    
    
   
    @IBOutlet weak var collectionView: UICollectionView!
    
//    var items: [Item] = [Item(imageName: "1"),
//                         Item(imageName: "macbook4"),
//                         Item(imageName: "macbook"),
//                         Item(imageName: "1"),
//                         Item(imageName: "macbook4"),
//                         Item(imageName: "macbook"),
//                         Item(imageName: "1"),
//                         Item(imageName: "macbook4"),
//                         Item(imageName: "macbook"),
//                         Item(imageName: "1")]
    
    var CollectionViewFlowLayout: UICollectionViewFlowLayout!
    let cellIdentifier = "CollectionViewCell"
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpCollectionView()
        LoadData()
       
 
    }
    
    func LoadData(){
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        Alamofire.request("https://api.themoviedb.org/3/discover/movie?api_key=6557d01ac95a807a036e5e9e325bb3f0&sort_by=" + SortWith).responseJSON { (Response) in
            let json = JSON(Response.value)
            print("!!!!!!!!!!!!!!!!!!!")
            print("in load data sortwith = ",SortWith)
            json["results"].array?.forEach({ (currentMovie) in
                let name = currentMovie["original_title"].stringValue
                let rate = currentMovie["vote_average"].floatValue
                let overview = currentMovie["overview"].stringValue
                let poster = currentMovie["poster_path"].stringValue
                let date = currentMovie["release_date"].stringValue
                let id = currentMovie["id"].stringValue
                let currentMovie = Movie(id:id , release_date: date, original_title: name, poster_Path:poster , overview:overview , Rate: rate)
                self.Movies.append(currentMovie)
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Movies", in: context)
                let newEntity = NSManagedObject(entity: entity!, insertInto: context)
                newEntity.setValue(name, forKey: "name")
                newEntity.setValue(overview, forKey: "overview")
                newEntity.setValue(rate, forKey: "rate")
                newEntity.setValue(id, forKey: "id")
                newEntity.setValue(date, forKey: "date")
                newEntity.setValue(poster, forKey: "path")

                do{
                    try context.save()
                    print("WELL SAVED")
                }
                catch{
                    print("FAILED TO SAVE")
                }

                print("FROM ALAMOFIRE.....................")
                self.collectionView.reloadData()
                
                
            })
            }}
    else{
    print("Internet Connection not Available!")
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
            request.returnsObjectsAsFaults = false
            do{
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject]{
                    let name = data.value(forKey: "name")
                    let rate = data.value(forKey: "rate")
                    let overview = data.value(forKey: "overview")
                    let date = data.value(forKey: "date")
                    let id = data.value(forKey: "id")
                    let path = data.value(forKey: "path")
                    let currentMovie = Movie(id:id as! String , release_date: date as! String, original_title: name as! String, poster_Path:path as! String , overview:overview as! String , Rate: rate as! Float)
                    self.Movies.append(currentMovie)
                    
                    
                }
            }
            catch{
                print("FETCHING FAILED")
                
            }
            print("FROM COREDATA.....................")
            self.collectionView.reloadData()
     
    }
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewItemSize()
    }
    
    private func setUpCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func setupCollectionViewItemSize() {
       
        if CollectionViewFlowLayout == nil {
            
            let numberOfItemPerRow: CGFloat = 2
            let lineSpacing: CGFloat = 5
            let insertItemSpacing: CGFloat = 15
            
            let width = (collectionView.frame.width - (numberOfItemPerRow - 1) * insertItemSpacing) / numberOfItemPerRow
            let hieght = width * 1.5
            
            CollectionViewFlowLayout = UICollectionViewFlowLayout()
            CollectionViewFlowLayout.itemSize = CGSize(width: width, height: hieght)
            CollectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            CollectionViewFlowLayout.scrollDirection = .vertical
            CollectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionView.setCollectionViewLayout(CollectionViewFlowLayout, animated: true)
        }
    }
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return Movies.count
     
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var ImgURL : String = ""
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        if (Movies.count > 0){
            print("RELODING")
        ImgURL = BaseURL+Size+self.Movies[indexPath.row].poster_Path
            print("PATH= ",self.Movies[indexPath.row].poster_Path)
            print("IMGURL = ",ImgURL)
        }
        cell.imageView?.sd_setImage(with: URL(string:ImgURL), placeholderImage: UIImage(named: "Default3"), options: SDWebImageOptions.highPriority, completed: { (DownloadedImage, Error, CacheType, DownloadURL) in
            if let Error = Error {
                print("ERROR DOWNLOADING IMAGE\(Error.localizedDescription) ")
            }
            else {
                print("success")
            }
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt:\(indexPath)")
        let selectedMovie = self.Movies[indexPath.row]
        if let DetailedVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC{
            DetailedVC.SelectedMovie = selectedMovie
self.navigationController?.pushViewController(DetailedVC, animated: true)
            
        }
      

    }
    
    
}
