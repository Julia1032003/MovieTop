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
    
    var movies = [MoviesData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getMoiveInfo()
    }
    
    //加入TableView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "secondInfo"{
               SecondMovieTableController = segue.destination as? SecondMovieTableViewController
            }
        }
    
    //每三秒換一張電影海報
    func time(){
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true){
            (timer) in self.newImage()
        }
    }
    
    //換海報
    func newImage(){
        index = (index + 1) % movies.count
        setMovieInfo(film: movies[index])
        //getMoiveInfo()
        
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
                            
                        self.movies = moviesData.results
                        
                        DispatchQueue.main.async {
                            if  self.movies.count > 0 {
                                self.setMovieInfo(film:self.movies[self.index])
                                self.time()


                            }
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
    
    //顯示電影海報
    func setMovieInfo(film:MoviesData){
        if let imageAddress = film.poster_path{
            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/" + imageAddress){
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
