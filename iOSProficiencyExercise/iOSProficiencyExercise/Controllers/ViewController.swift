//
//  ViewController.swift
//  iOSProficiencyExercise
//
//  Created by Hardik on 6/17/18.
//  Copyright © 2018 Hardik. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var mainTableView: UITableView!     // Outlet for tableview
    var pullToRefresh: UIRefreshControl! // Pull to refresh control
    var arrayFactData = [FactDataModel]() // Array to Store the fact data

    override func viewDidLoad() {
        super.viewDidLoad()

        // Adding Right bar button for Refresh data
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target:self, action:#selector(refreshData))

        // Setting Table View Estimated Row Height
        self.mainTableView.rowHeight = UITableViewAutomaticDimension
        self.mainTableView.estimatedRowHeight = (Utils.deviceType() == .iPhone) ? 65.0 : 120.0

        // Adding Tableview's pull to refresh control and setting target method to be called
        pullToRefresh = UIRefreshControl()
        if #available(iOS 10.0, *) {
            self.mainTableView.refreshControl = pullToRefresh
        } else {
            // Fallback on earlier versions
            self.mainTableView.addSubview(pullToRefresh)
        }
        pullToRefresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: - Refresh Data Method
    @objc func refreshData()
    {
       self.loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Extention For API Call
extension ViewController {
    func loadData()
    {
        //Start network indicator which will indicate user that network service is running
        UIApplication.shared.isNetworkActivityIndicatorVisible =  true
        ApiClient.GetAPI(url: urlForJson) { (success, dictData) in
            //Start main thread to update UI
            DispatchQueue.main.async
                {
                    // Stop network indicator
                    UIApplication.shared.isNetworkActivityIndicatorVisible =  false
                    //Check if network call failed than show alert message
                    if success == false{
                        Utils.showAlert(title: "Error", Message: "Error while fetching data from \(urlForJson)", buttonText: "Ok", viewController: self)
                    }else{
                        //Remove old data once we have new data
                        self.arrayFactData.removeAll()
                        if let  array = dictData["rows"] as? [[String:AnyObject]]{
                            for dict in array{
                                self.arrayFactData.append(FactDataModel(dictInfo: dict))
                            }
                        }
                        //Check and set title of view based on title from feeds
                        if let  title = dictData["title"] as? String{
                            self.title = title
                        }
                        //Hide pull to refresh control and reload table data
                        self.pullToRefresh.endRefreshing()
                        self.mainTableView.reloadData()
                    }
            }
        }
    }

}

// Mark :- Extention For Datasource Methods
extension ViewController
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return single for to show message if we do not have any data loaded yet. Else return array data count
        return (self.arrayFactData.count == 0) ? 1 : self.arrayFactData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier =  "FactDataCell"
        var cell =  tableView.dequeueReusableCell(withIdentifier: identifier)

        // Check for cell if not created yet creat new cell
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)
        }

        // Check if array has data if not than show message to pull to refresh or press button to load data
        if(self.arrayFactData.count == 0){
                cell?.detailTextLabel?.text = messageGetData
        }else{
            // Get Fact data from array based on index path row
            let fact =  arrayFactData[indexPath.row]
            cell?.textLabel?.text = fact.title.trimmingCharacters(in: .whitespacesAndNewlines)
            cell?.detailTextLabel?.text = fact.details.trimmingCharacters(in: .whitespacesAndNewlines)

            //Set image to nil so don't get any space in cell if image url is wrong of nil
            cell?.imageView?.image = nil
            if(fact.imageUrl.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
                // Triming url for extra spaces
                let imageUrl = URL(string:fact.imageUrl.trimmingCharacters(in: .whitespacesAndNewlines))
                let weakCell = cell
                cell?.imageView?.sd_setImage(with: imageUrl, placeholderImage: nil,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                    // Check if image is not nil and resize image to proper size based on device type.
                    if image != nil {
                        weakCell?.imageView?.image = Utils.resizeImage(with: image, scaledTo: (Utils.deviceType() == .iPhone) ? CGSize(width: 45.0, height: 45.0) : CGSize(width: 100.0, height: 100.0))
                    }
                    //Relayout tableview cell to adjust image
                    weakCell?.layoutIfNeeded()
                    weakCell?.layoutSubviews()
                })
            }
        }
        return cell!;
    }

}
// Mark :- Extention For Delegate Methods
extension ViewController
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Show alert with fact title and details on selecting row
        if(self.arrayFactData.count > 0){
            Utils.showAlert(title: self.arrayFactData[indexPath.row].title, Message: self.arrayFactData[indexPath.row].details, buttonText: "Dismiss", viewController: self)
        }
        //Deselect row
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
