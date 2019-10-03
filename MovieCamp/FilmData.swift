//
//  FilmData.swift
//  MovieCamp
//
//  Created by Julia Wang on 2019/9/9.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import Foundation


//取得電影資料
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





