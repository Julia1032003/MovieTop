//
//  FilmData.swift
//  MovieCamp
//
//  Created by Julia Wang on 2019/9/9.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import Foundation


//取得TMDB電影資料
struct MoviesData: Codable {
    var title: String?
    var vote_average: Double?
    var release_date: String?
    var poster_path: String?
    var id: Int
    var overview: String?
    
}

struct Film: Codable {
    var results:[MoviesData]
}

//預告片
struct MovieTrailers: Codable{
    var key: String?
    var name: String?
}

struct TrailersInfo: Codable {
    var results:[MovieTrailers]
}

//儲存至最愛電影清單
struct LoveMoviesList: Codable {
    var title: String?
    var vote_average: String?
    var release_date: String?
    var poster_path: String?
    var id: Int
    var overview: String?
    var trailerurl: String?
    
    static let  documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func saveToLoveList(lovelist:[LoveMoviesList]){
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(lovelist){
            let url = documentsDirectory.appendingPathComponent("LoveList")
            try? data.write(to: url)
        }
    }
    
    static func readLoveList() -> [LoveMoviesList]? {
        let propertyDecoder = PropertyListDecoder()
        let url = documentsDirectory.appendingPathComponent("LoveList")
        if let data = try? Data(contentsOf: url), let lovelist = try? propertyDecoder.decode([LoveMoviesList].self, from: data){
            return lovelist
        }else{
            return nil
        }
        
    }
}

//儲存至待看電影清單
struct MoviesWatchList: Codable {
    var title: String?
    var vote_average: String?
    var release_date: String?
    var poster_path: String?
    var id: Int
    var overview: String?
    var trailerurl: String?
    
    static let  documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func saveToWatchList(watchlist:[MoviesWatchList]){
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(watchlist){
            let url = documentsDirectory.appendingPathComponent("watchList")
            try? data.write(to: url)
        }
    }
    
    static func readWatchList() -> [MoviesWatchList]? {
        let propertyDecoder = PropertyListDecoder()
        let url = documentsDirectory.appendingPathComponent("watchList")
        if let data = try? Data(contentsOf: url), let watchlist = try? propertyDecoder.decode([MoviesWatchList].self, from: data){
            return watchlist
        }else{
            return nil
        }
        
    }
}






