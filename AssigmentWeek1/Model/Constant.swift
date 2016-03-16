//
//  Constant.swift
//  AssigmentWeek1
//
//  Created by Ngoc Do on 3/12/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import Foundation
import UIKit

let width:CGFloat = UIScreen.mainScreen().bounds.width
let heightOfErrorView:CGFloat = 40.0
let clientId = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
let urlNowPlaying = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(clientId)")
let urlTopMoview = NSURL(string:"https://api.themoviedb.org/3/movie/top_rated?api_key=\(clientId)")

let urlLow = "https://image.tmdb.org/t/p/w45"
let urlHigh = "https://image.tmdb.org/t/p/original"
let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
