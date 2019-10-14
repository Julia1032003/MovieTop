//
//  LoveListTableViewController.swift
//  MovieCamp
//
//  Created by Julia Wang on 2019/10/8.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import UIKit

class LoveListTableViewController: UITableViewController {
    
    var lovelist = [LoveMoviesList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loveList = UserDefaults.standard.array(forKey: "LoveList") as? [[String:Any]]{
            var lovelist = [LoveMoviesList]()
            for loveMovie in loveList{
                let title = loveMovie["title"] as? String ?? ""
                let vote_average = loveMovie["vote_average"] as? String ?? ""
                let release_date = loveMovie["release_date"] as? String ?? ""
                let poster_path = loveMovie["poster_path"] as? String ?? ""
                let id = loveMovie["id"] as? String ?? ""
                let overview = loveMovie["overview"] as? String ?? ""
                let trailerurl = loveMovie["trailerurl"] as? String ?? ""
                lovelist.append(LoveMoviesList(title: title, vote_average: vote_average, release_date: release_date, poster_path: poster_path, id: Int(id) ?? 0 , overview: overview, trailerurl: trailerurl))
                print(lovelist)
                
            }
            
        }
    
        /*if let lovelist = LoveMoviesList.readLoveList(){
            self.lovelist = lovelist
            print(lovelist)
        }*/
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lovelist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lovecell", for: indexPath) as! LoveTableViewCell
        let loveMovie = lovelist[indexPath.row]
        
        cell.loveMovieTitleLabel.text = loveMovie.title
        cell.loveMovieReleaseDateLabel.text = loveMovie.release_date
        cell.loveMovieVoteLabel.text = loveMovie.vote_average
        cell.loveMovieImage.image = nil
        if let imageAddress = loveMovie.poster_path{
            if let imageURL = URL(string: imageAddress){
                let task = URLSession.shared.dataTask(with: imageURL){(data, response , error ) in
                    if let data = data{
                        DispatchQueue.main.async {
                            cell.loveMovieImage.image = UIImage(data: data)
                        }
                    }
                }
                task.resume()
            }
        }

        // Configure the cell...

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
