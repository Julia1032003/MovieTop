//
//  FirstMovieViewController.swift
//  MovieCamp
//
//  Created by Julia Wang on 2019/9/9.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import UIKit

class FirstMovieViewController: UIViewController {

    @IBOutlet var TopMoiveImageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    //連結圖片高度條件的 outlet imageViewHeightConstraint
    var index = 0
    var SecondMovieTableController:SecondMovieTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMoiveInfo()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "secondInfo"{
               SecondMovieTableController = segue.destination as? SecondMovieTableViewController
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
                        let moviesInfoArray = MoviesInfo(title: moviesTitle, vote_average: moviesVote, release_date: moviesReleaseDate, poster_path: moviesImage)
                        
                        DispatchQueue.main.async {
                            self.setMovieInfo(film:moviesInfoArray)
                            print(moviesData)
                            
                        }
                    
                    }catch{
                        
                    print(error)
                }
            }
        }
            
          task.resume()
        }
    }
    
    func setMovieInfo(film:MoviesInfo){
        if let imageAddress = film.poster_path{
            if let imageURL = URL(string: imageAddress){
                let task = URLSession.shared.downloadTask(with: imageURL) {
                    (data, response, error) in
                    
                    if error != nil{
                        DispatchQueue.main.async {
                            self.popAlert()
                        }
                        print(error!.localizedDescription)
                        return
                    }
                    if let getImageURL = data {
                        do{
                            let getImage = UIImage(data: try Data(contentsOf: getImageURL))
                            DispatchQueue.main.async {
                            self.TopMoiveImageView.image = getImage
                            
                           }
                        }catch{
                            DispatchQueue.main.async {
                            self.popAlert()
                            }
                            print(error.localizedDescription)
                            
                        }
                    }
            }
            task.resume()
        }
      }
      
        //SecondMovieTableController?.titleLabel.text = film.title
        //SecondMovieTableController?.voteLabel.text = "\(String(describing: film.vote_average))"
        //SecondMovieTableController?.releaseDateLabel.text = film.release_date
    }
        
    func popAlert() {
            
            let alert = UIAlertController(title: "Something Wrong", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
