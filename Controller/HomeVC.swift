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

struct Item {
   var imageName: String
}
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
    
    var items: [Item] = [Item(imageName: "1"),
                         Item(imageName: "macbook4"),
                         Item(imageName: "macbook"),
                         Item(imageName: "1"),
                         Item(imageName: "macbook4"),
                         Item(imageName: "macbook"),
                         Item(imageName: "1"),
                         Item(imageName: "macbook4"),
                         Item(imageName: "macbook"),
                         Item(imageName: "1")]
    
    var CollectionViewFlowLayout: UICollectionViewFlowLayout!
    let cellIdentifier = "CollectionViewCell"
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpCollectionView()
        LoadData()
       
 
    }
    
    func LoadData(){
        Alamofire.request("https://api.themoviedb.org/3/discover/movie?api_key=6557d01ac95a807a036e5e9e325bb3f0&sort_by=" + SortWith).responseJSON { (Response) in
            let json = JSON(Response.value)
            print("!!!!!!!!!!!!!!!!!!!")
            print("in load data sortwith = ",SortWith)
            json["results"].array?.forEach({ (currentMovie) in
                let currentMovie = Movie(id: currentMovie["id"].stringValue, video: currentMovie["Video"].stringValue, release_date: currentMovie["release_date"].stringValue, original_title: currentMovie["original_title"].stringValue, poster_Path: currentMovie["poster_path"].stringValue, overview: currentMovie["overview"].stringValue, Rate: currentMovie["vote_average"].stringValue)
                self.Movies.append(currentMovie)
                print("current movie title = ",self.Movies[0].original_title)
                print(".....................")
                self.collectionView.reloadData()
                
                
            })
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
            let insertItemSpacing: CGFloat = 10
            
            let width = (collectionView.frame.width - (numberOfItemPerRow - 1) * insertItemSpacing) / numberOfItemPerRow
            let hieght = width * 2
            
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
