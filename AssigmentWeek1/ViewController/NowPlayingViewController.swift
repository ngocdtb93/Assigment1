//
//  NowPlayingViewController.swift
//  AssigmentWeek1
//
//  Created by Ngoc Do on 3/12/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import UIKit
import AFNetworking
import Spring

class NowPlayingViewController: GeneralViewController, UITableViewDelegate, UISearchBarDelegate {
    
    var listData:[NSDictionary]?
    var filteredTableData:[NSDictionary]?
    var searchActive:Bool = false
    let imagePath = "https://image.tmdb.org/t/p/w342"
    let normalFont = UIFont(name: "Menlo", size: 15.0)
    let boldFont = UIFont(name:"Menlo-Bold" , size: 18.0)
    

    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var heightOfErrorView: NSLayoutConstraint!
    @IBOutlet weak var bottomContraintTableView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        //Load data
        fetchData()
        
        //register keyboard funtion
         bottomContraint = self.bottomContraintTableView
        keyboardFunction()
        
        //pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refreshControlAction:"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

        // Do any additional setup after loading the view.
    }
    
    func refreshControlAction(refreshControl:UIRefreshControl){
        fetchData()
        refreshControl.endRefreshing()
    }
    //MARk; - Load data

    func fetchData() {
        //check internet
        
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock { (status:AFNetworkReachabilityStatus) -> Void in
            if( status == .NotReachable){
                self.heightOfErrorView.constant = 40.0
                self.viewError.hidden = false
            }else{
                self.view.showLoading()
                self.heightOfErrorView.constant = 0.0
                 self.viewError.hidden = true
                let clientId = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
                let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(clientId)")
                let request = NSURLRequest(URL: url!)
                let session = NSURLSession(
                    configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                    delegate:nil,
                    delegateQueue:NSOperationQueue.mainQueue()
                )
                
                let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                    completionHandler: { (dataOrNil, response, error) in
                        if let data = dataOrNil {
                            if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                data, options:[]) as? NSDictionary {
                                    
                                    self.listData = (responseDictionary["results"] as? [NSDictionary])!
                                    self.tableView.reloadData()
                                    self.view.hideLoading()
                            }
                        }
                });
                task.resume()
                

            }
        }
            
        
        
        
            
    }
    
    //MARK: - UITableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive){
            return self.filteredTableData!.count
            
        } else {
        
            return listData?.count ?? 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        var movie:NSDictionary!
        if(searchActive && searchBar.text != ""){
            movie = filteredTableData![indexPath.row]
        }else{
            movie = listData![indexPath.row]
        }
        
        cell.lblTitle.text =  movie["original_title"] as?String
        cell.lblContent.text = movie["overview"] as? String
        
        let queue = dispatch_get_global_queue(0, 0)
        dispatch_async(queue){
            if let posterPath = movie["poster_path"] as? String {
                let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
                let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            dispatch_async(dispatch_get_main_queue()){
            
                cell.filmImage.animation = "fadeIn"
                cell.filmImage.duration = 3.0
                cell.filmImage.animate()
                cell.filmImage.setImageWithURL(posterUrl!)
                }
            }else {
                cell.filmImage.image = nil
            }
        }
        
        
        return cell
    }
    
    
    
    //MARK: - UISearchBar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
            searchActive = true;
            searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        searchActive = false;
        searchBar.setShowsCancelButton(false, animated: true)
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
        
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text! != ""){
            self.filteredTableData = self.listData!.filter({( chosePost : NSDictionary) -> Bool in
                
                let title = chosePost["original_title"]!
                let stringMatch = (title.uppercaseString).rangeOfString(searchBar.text!.uppercaseString)
                return (stringMatch != nil)
            })
            self.tableView.reloadData()
        }else{
            searchActive = false
            self.searchBar.resignFirstResponder()
            self.tableView.reloadData()
            
        }
    }
    
    //MARK: - prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! DetailViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        if(searchActive){
            vc.movie = filteredTableData![indexPath!.row]
        }else{
            vc.movie = listData![indexPath!.row]
        }
    }
    

}

