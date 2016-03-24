//
//  TopRateViewController.swift
//  AssigmentWeek1
//
//  Created by Ngoc Do on 3/12/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import UIKit
import AFNetworking
import Spring

class TopRateViewController: GeneralViewController {

    var listData:[Movie]?
    var filteredTableData:[Movie]?
    var searchActive:Bool = false
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
    
    //MARK: - Load data
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
                //load data
                Movie.loadData(urlTopMoview!, completion: { (movies) -> Void in
                    if(movies.count > 0){
                        self.listData = movies
                        self.tableView.reloadData()
                        self.view.hideLoading()
                    }
                })
                
                
            }
        }
    }
    
    //MARK: - prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! DetailViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        if(searchActive && searchBar.text != ""){
            vc.movie = filteredTableData![indexPath!.row]
        }else{
            vc.movie = listData![indexPath!.row]
        }
    }
    
}


extension NowPlayingViewController:UITableViewDelegate, UITableViewDataSource{
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
        var movie:Movie!
        if(searchActive && searchBar.text != ""){
            movie = filteredTableData![indexPath.row]
        }else{
            movie = listData![indexPath.row]
        }
        
        cell.lblTitle.text =  movie.title
        cell.lblContent.text = movie.overview
        
        let queue = dispatch_get_global_queue(0, 0)
        dispatch_async(queue){
            
            let posterUrl = NSURL(string: posterBaseUrl + movie.urlImage!)
            dispatch_async(dispatch_get_main_queue()){
                
                cell.filmImage.animation = "fadeIn"
                cell.filmImage.duration = 3.0
                cell.filmImage.animate()
                cell.filmImage.setImageWithURL(posterUrl!)
            }
        }
        return cell
    }
    
}

extension NowPlayingViewController:UISearchBarDelegate{
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
            self.filteredTableData = self.listData!.filter({( chosePost : Movie) -> Bool in
                
                let title = chosePost.title
                let stringMatch = (title!.uppercaseString).rangeOfString(searchBar.text!.uppercaseString)
                return (stringMatch != nil)
            })
            self.tableView.reloadData()
        }else{
            searchActive = false
            self.searchBar.resignFirstResponder()
            self.tableView.reloadData()
            
        }
    }
    
}
