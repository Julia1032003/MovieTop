//
//  FilmData.swift
//  MovieCamp
//
//  Created by Julia Wang on 2019/9/9.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import Foundation

//存電影資料
struct MoviesInfo: Codable {
    var title: String?
    var vote_average: Double?
    var release_date: String?
    var poster_path: String?
    
}

//取得電影資料
struct MoviesData: Codable {
    var title: String?
    var vote_average: Double?
    var release_date: String?
    var poster_path: String?
    
}

struct Film: Codable {
    var results:[MoviesData]
}

//電影相關圖片size

struct ImageInfo: Codable {
    var base_url:String?
    var poster_sizes:[ImageInfo]
}

struct ImageSize: Codable{
    var w500:String
    var original:String
}



