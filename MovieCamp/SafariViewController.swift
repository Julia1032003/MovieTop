//
//  SafariViewController.swift
//  MovieCamp
//
//  Created by Julia Wang on 2019/10/2.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import UIKit
import SafariServices

class SafariViewController: UIViewController {
    
    var moviesArray:MoviesData?
    var trailersArray = [MovieTrailers]()
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        getTrailerKey(film:self.moviesArray?.id)

        // Do any additional setup after loading the view.
    }
    
   
    
    
    
    
    func getTrailerKey(film:MoviesData){
        
        let urlStr = "https://api.themoviedb.org/3/movie/\(film.id)/videos?api_key=bee04d91e381af841c21674aad134443&language=en-US"
        if let url = URL(string: urlStr){
            let task = URLSession.shared.dataTask(with: url){(data, response , error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if let data = data , let trailerkey = try? JSONDecoder().decode(TrailersInfo.self, from: data){
                    self.trailersArray = trailerkey.results
                    
                    DispatchQueue.main.async {
                        let url = URL(string:"http://youtube.com/watch?v=\(trailervideo.key!))")!
                        let safariVC = SFSafariViewController(url:url)
                        
                        self.present(safariVC , animated: true , completion: nil)
                        
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
