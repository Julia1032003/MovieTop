//
//  DetilViewController.swift
//  MovieCamp
//
//  Created by Julia Wang on 2019/10/3.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import UIKit
import SafariServices

class DetilViewController: UIViewController {
    
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    
    var moviesArray:MoviesData?
    var trailersArray = [MovieTrailers]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getid()
        getSelectInfo()
        getTrailerKey()

        // Do any additional setup after loading the view.
    }
    
    //測試有抓到id用
    func getid(){
        print(moviesArray?.id as Any)
    }
    
    func getSelectInfo(){
        movieTitleLabel.text = moviesArray?.title
        overViewLabel.text = moviesArray?.overview
        movieImageView.image = nil
        if let imageAddress = moviesArray?.poster_path{
            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/" + imageAddress){
                let task = URLSession.shared.dataTask(with: imageURL){(data, response, error ) in
                    if let data = data{
                        DispatchQueue.main.async {
                            self.movieImageView.image = UIImage(data: data)
                        }
                    }
                    
                    }
                task.resume()
            }
        }
        
    }
    
    
    @IBAction func playTrailer(_ sender: Any) {
      
        let url = URL(string:"http://youtube.com/watch?v=\(trailersArray[0].key!))")!
        let safariVC = SFSafariViewController(url:url)
        
        present(safariVC , animated: true , completion: nil)
        
        
    }
    
    func getTrailerKey(){
        
        let urlStr = "https://api.themoviedb.org/3/movie/\(moviesArray!.id)/videos?api_key=bee04d91e381af841c21674aad134443&language=en-US"
        if let url = URL(string: urlStr){
            let task = URLSession.shared.dataTask(with: url){(data, response , error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if let data = data , let trailerkey = try? JSONDecoder().decode(TrailersInfo.self, from: data){
                    self.trailersArray = trailerkey.results
                    
                    DispatchQueue.main.async {
                        print(trailerkey)
                    }
                    
                }
            }
            task.resume()
        }
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
