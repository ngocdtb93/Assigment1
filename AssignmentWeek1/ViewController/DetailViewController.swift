//
//  DetailViewController.swift
//  AssigmentWeek1
//
//  Created by Ngoc Do on 3/13/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import UIKit
import Spring

class DetailViewController: UIViewController {
    
    @IBOutlet weak var movieImage: UIImageView!
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblReleaseDate: UILabel!

    @IBOutlet weak var lblVote: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    
    @IBOutlet weak var heightOfViewDetail: NSLayoutConstraint!
    
    
    @IBOutlet weak var heightOfContentView: NSLayoutConstraint!
    
    var movie:NSDictionary?
    let urlLow = "https://image.tmdb.org/t/p/w45"
    let urlHigh = "https://image.tmdb.org/t/p/original"
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("loadHighQualityImage"), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.view.showLoading()
        loadData()
        updateViewSize()
        self.view.hideLoading()
         //loadHighQualityImage()
    }


    func loadData(){
         if let posterPath = movie!["poster_path"] as? String {
            let posterUrl = NSURL(string: urlLow + posterPath)
            movieImage.setImageWithURL(posterUrl!)
            //low high quality image
        }
        
        lblName.text =  movie!["original_title"] as?String
        lblReleaseDate.text = movie!["release_date"] as? String
        lblVote.text = "\(movie!["vote_count"] as! Int)"
        lblOverview.text = movie!["overview"] as? String
    }
    func updateViewSize(){
        heightOfViewDetail.constant = calculateHeightDetailView()
    }
    
    func calculateHeightDetailView()->CGFloat{
        let hieghtName = General.heightForLabel( (movie!["original_title"] as?String)!, font: UIFont(name: "Helvetica-Bold", size: 18)!, width: width - 32)
        let hieghtOverview = General.heightForLabel( (movie!["overview"] as?String)!, font: UIFont(name: "Helvetica", size: 14)!, width: width - 32)
        return hieghtName + hieghtOverview + 70
        
    }
    func loadHighQualityImage(){
        if( movieImage.image  != nil){
        let queue = dispatch_get_global_queue(0, 0)
        dispatch_async(queue){
            let posterPath = self.movie!["poster_path"] as? String
            let posterUrl = NSURL(string: self.urlHigh + posterPath!)
            dispatch_async(dispatch_get_main_queue()){
                self.movieImage.setImageWithURL(posterUrl!)
                self.timer!.invalidate()
            }
        }
        }
    }

}
