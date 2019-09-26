//
//  SecondMovieTableViewController.swift
//  MovieCamp
//
//  Created by Julia Wang on 2019/9/9.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import UIKit

class SecondMovieTableViewController: UITableViewController {

    
    var moviesArray = [MoviesData]()
    var index = 0
    
    //設定表格的 contentInse，讓表格的上方多出一塊高度 450 points 的空間
    let imageOriginalHeight: CGFloat = 450
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMoiveInfo()
        
        tableView.contentInset = UIEdgeInsets(top: imageOriginalHeight, left: 0, bottom: 0, right: 0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return moviesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "movieforcell", for: indexPath) as! MovieListTableViewCell
           let movielist = moviesArray[indexPath.row]
           
              cell.movieImageView.image = UIImage(named:movielist.poster_path!)
              cell.titleLabel.text = movielist.title
              cell.releaseDateLabel.text = movielist.release_date
              cell.voteLabel.text = "\(String(describing: movielist.vote_average))"
               
              
               // Configure the cell...
               return cell
    }
        
    
    
    //捲動時調整圖片的高度和亮度
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
           
            //利用 parent property 讀取容納 SecondTableViewController 的 FirstMovieViewController 物件。
            let controller = parent as? FirstMovieViewController
            //設定開始的 contentOffset.y 將等於 -imageOriginalHeight，也就是 -450。
            let originalOffsetY = -imageOriginalHeight
            //計算 scroll view 捲動的距離。往下捲動時 scrollView.contentOffset.y 會愈小，相減的結果將為負數，因此我們利用 abs 讓相減的結果一定為正數。
            let moveDistance = abs(scrollView.contentOffset.y - originalOffsetY)
            
            //從起始位置往下捲動時 scrollView.contentOffset.y 將小於 originalOffsetY，此時我們修改圖片的高度條件，讓它依據捲動的距離變高。相反的，從起始位置往上捲動時我們將設定表格的背景顏色，讓圖片隨著捲動的距離逐漸變暗。
            if scrollView.contentOffset.y < originalOffsetY  {
                controller?.imageViewHeightConstraint.constant = imageOriginalHeight + moveDistance
                tableView.backgroundColor = UIColor.clear
            } else {
                controller?.imageViewHeightConstraint.constant = imageOriginalHeight
                tableView.backgroundColor = UIColor(white: 0, alpha: moveDistance / imageOriginalHeight)

            }
        }
    
    func getMoiveInfo(){
            let urlStr = "https://api.themoviedb.org/3/discover/movie?api_key=bee04d91e381af841c21674aad134443&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&primary_release_year=2019.json"
            if let url = URL(string: urlStr) {
                let task = URLSession.shared.dataTask(with: url) { (data, response , error) in
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    if let data = data{
                        
                        do{
                            let moviesData = try JSONDecoder().decode(Film.self, from: data)
                            let moviesTitle = moviesData.results[self.index].title
                            let moviesVote = moviesData.results[self.index].vote_average
                            let moviesImage = "https://image.tmdb.org/t/p/w500/" + moviesData.results[self.index].poster_path!
                            let moviesReleaseDate = moviesData.results[self.index].release_date
                            let moviesInfoArray = MoviesData(title: moviesTitle, vote_average: moviesVote, release_date: moviesReleaseDate, poster_path: moviesImage)
                            
                            DispatchQueue.main.async {
                                self.moviesArray.append(moviesInfoArray)
                                print(moviesInfoArray)
                               
                            }
                        
                        }catch{
                            
                        print(error)
                    }
                }
            }
                
              task.resume()
            }
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

    
    
 }
 
