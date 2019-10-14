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
    @IBOutlet weak var voteLabel: UILabel!
    
    var moviesArray:MoviesData?
    var trailersArray = [MovieTrailers]()
    var moviesWatchList:MoviesWatchList?
    var loveMoviesList:LoveMoviesList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getid()
        getSelectInfo()
        getTrailerKey()

        // Do any additional setup after loading the view.
    }
    
    /*/測試有抓到id用
    func getid(){
        print(moviesArray?.id as Any)
    }*/
    
    //載入電影海報、電影名稱、電影簡介
    func getSelectInfo(){
        movieTitleLabel.text = moviesArray?.title
        overViewLabel.text = moviesArray?.overview
        voteLabel.text = moviesArray?.vote_average?.description
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
    
    //播放預告片button(Youtube網址＋預告片的key＝完整電影預告片網址)
    @IBAction func playTrailer(_ sender: Any) {
      
        let url = URL(string:"http://youtube.com/watch?v=\(trailersArray[0].key!)")!
        let safariVC = SFSafariViewController(url:url)
        
        present(safariVC , animated: true , completion: nil)
        
        
    }
    
    //取得電影的key
    func getTrailerKey(){
        
        let urlStr = "https://api.themoviedb.org/3/movie/\(moviesArray!.id)/videos?api_key=bee04d91e381af841c21674aad134443&language=en-US"
        if let url = URL(string: urlStr){
            let task = URLSession.shared.dataTask(with: url){(data, response , error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if let data = data , let trailerkey = try? JSONDecoder().decode(TrailersInfo.self, from: data){
                    self.trailersArray = trailerkey.results
                    
                    DispatchQueue.main.async {
                        //print(trailerkey)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    //儲存電影至最愛清單
    @IBAction func saveToLoveList(_ sender: Any) {
        
        if moviesArray!.id == self.loveMoviesList?.id{
            return showAlertMessage(title: "Oops!", message: "The movie have been add to your list.")
        }else{
            
            let movieTitle = movieTitleLabel.text ?? ""
            let movieOverView = overViewLabel.text ?? ""
            let movievote = voteLabel.text ?? ""
            let movieID = moviesArray!.id
            let movieReleaseDate = moviesArray!.release_date
            let movieImage = "https://image.tmdb.org/t/p/w500\(moviesArray!.poster_path!)"
            let trailerurl = "http://youtube.com/watch?v=\(trailersArray[0].key!))"
            
            let loveMoviesList = [LoveMoviesList(title: movieTitle, vote_average: movievote, release_date: movieReleaseDate, poster_path: movieImage, id: movieID, overview: movieOverView, trailerurl: trailerurl)]
            //LoveMoviesList.saveToLoveList(lovelist: [loveMoviesList])
            var loveMovies = [[String:Any]] ()
            for loveMoviesList in loveMoviesList {
                loveMovies.append(["title" : loveMoviesList.title!, "vote_average": loveMoviesList.vote_average!, "release_date": loveMoviesList.release_date!, "poster_path": loveMoviesList.poster_path!, "id": loveMoviesList.id, "overview": loveMoviesList.overview!, "trailerurl": loveMoviesList.trailerurl!])
            }
            UserDefaults.standard.set(loveMovies, forKey: "LoveList")
            print(loveMovies)
            

        }
    }
    
    
    //儲存電影至待看清單的button
    @IBAction func saveToWatchList(_ sender: Any) {
        
        if moviesArray!.id == self.moviesWatchList?.id {
            return showAlertMessage(title: "Oops!", message: "The movie have been add to your list.")
        }else{
        
        let movieTitle = movieTitleLabel.text ?? ""
        let movieOverView = overViewLabel.text ?? ""
        let movievote = voteLabel.text ?? ""
        let movieID = moviesArray!.id
        let movieReleaseDate = moviesArray!.release_date
        let movieImage = "https://image.tmdb.org/t/p/w500\(moviesArray!.poster_path!)"
        let trailerurl = "http://youtube.com/watch?v=\(trailersArray[0].key!))"
        
        moviesWatchList = MoviesWatchList(title: movieTitle, vote_average: movievote, release_date: movieReleaseDate, poster_path: movieImage, id: movieID, overview: movieOverView, trailerurl: trailerurl)
            
        
        if moviesWatchList != nil {
            print(moviesWatchList!)
            return showAlertMessage(title: "success!", message: "Please refer to the watch list")
        }else{
            return showAlertMessage(title: "fail!", message: "something wrong")
        }
      }
        
    }
    
    //提示訊息
    func showAlertMessage(title: String, message: String){
        let inputAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "confirm", style: .default, handler: nil)
        inputAlert.addAction(okAction)
        self.present(inputAlert, animated: true, completion: nil )
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
