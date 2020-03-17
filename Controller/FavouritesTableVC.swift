//
//  FavouritesTableVCTableViewController.swift
//  PopularMovies
//
//  Created by Marwa Zabara on 3/17/20.
//  Copyright © 2020 Marwa Zabara. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class FavouritesTableVC: UITableViewController {
        var Faves: [Movie] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("will appear")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Faves")
        // request.returnsObjectsAsFaults = false
        do{
            print("in do")
            let result = try context.fetch(request)
            Faves.removeAll()
            for data in result as! [NSManagedObject]{
                let name = data.value(forKey: "name")
                let rate = data.value(forKey: "rate")
                let overview = data.value(forKey: "overview")
                let date = data.value(forKey: "date")
                let id = data.value(forKey: "id")
                let path = data.value(forKey: "path")
                let currentMovie = Movie(id:id as! String , release_date: date as! String, original_title: name as! String, poster_Path:path as! String , overview:overview as! String , Rate: rate as! Float)
                self.Faves.append(currentMovie)
                
                print("after append")
                self.tableView.reloadData()
            }
        }
        catch{
            print("FETCHING FAILED")
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension FavouritesTableVC {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Faves.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FCell", for: indexPath) as! FaveCell
        cell.NameTxt.text = Faves[indexPath.row].original_title
        cell.YearTxt.text = Faves[indexPath.row].release_date
        let ImgURL = BaseURL+Size+self.Faves[indexPath.row].poster_Path
        print("PATH= ",self.Faves[indexPath.row].poster_Path)
        print("IMGURL = ",ImgURL)
        
        cell.Img?.sd_setImage(with: URL(string:ImgURL), placeholderImage: UIImage(named: "Default3"), options: SDWebImageOptions.highPriority, completed: { (DownloadedImage, Error, CacheType, DownloadURL) in
            if let Error = Error {
                print("ERROR DOWNLOADING IMAGE\(Error.localizedDescription) ")
            }
            else {
                print("success")
            }
        })
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectItemAt:\(indexPath)")
        let selectedMovie = self.Faves[indexPath.row]
        if let DetailedVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC{
            DetailedVC.SelectedMovie = selectedMovie
            self.navigationController?.pushViewController(DetailedVC, animated: true)
            
        }}
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Faves")
            
        var predicate : NSPredicate = NSPredicate()
            
        predicate = NSPredicate(format: "id == %@", Faves[indexPath.row].id)
            request.predicate = predicate

       
        do{
            let result = try context.fetch(request)
        for data in result as! [NSManagedObject]{
            context.delete(data)}
           
            do{
                try context.save()
                Faves.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .bottom)
                print("WELL DELETED")
                
            }
            catch{
                print("FAILED TO DELETE")
            }
           
        
        
       
            }
            catch{
                print("FETCHING FAILED")
                
                
            }
            
        }
    }
    
}
