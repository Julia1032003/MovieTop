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
    
    var SecondMovieTableController:SecondMovieTableViewController?
    var timer:Timer?
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        time()
        //畫面載入後即執行每秒換一張電影海報
    }
    
    //加入TableView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "secondInfo"{
               SecondMovieTableController = segue.destination as? SecondMovieTableViewController
            }
        }
    
    //每秒換一張電影海報
    func time(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
            (timer) in self.newImage()
        }
    }
    
    //亂數換海報
    func newImage(){
        index = Int.random(in: 0...20)
        getMoiveInfo()
    }
    
    
    //取得TMDB Top 20 電影資料
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
                            //print(moviesData)
                            
                        }
                    
                    }catch{
                        
                    print(error)
                }
            }
        }
            
          task.resume()
        }
    }
    
    //顯示電影海報
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
      
    }
    
    
    //提示訊息
    func popAlert() {
            
            let alert = UIAlertController(title: "Something Wrong", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
    }
    
    //關閉app畫面即停止timer，以防止在背景持續執行
    override func viewDidDisappear(_ animated: Bool) {
       timer?.invalidate()
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
