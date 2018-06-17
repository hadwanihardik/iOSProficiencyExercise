//
//  ViewController.swift
//  iOSProficiencyExercise
//
//  Created by Hardik on 6/16/18.
//  Copyright © 2018 Hardik. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var mainTableView: UITableView!
    var pullToRefresh: UIRefreshControl!
    var arrayData = [FactDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Adding Right bar button for Refresh data
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target:self, action:#selector(refreshData))
        // Setting Table View Estimated Row Height
        self.mainTableView.rowHeight = UITableViewAutomaticDimension
        self.mainTableView.estimatedRowHeight = (Utils.deviceType() == .iPhone) ? 65.0 : 120.0

        // Adding Tableview's pull to refresh control
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

// MARK: - For API Call

extension ViewController {
    func loadData()
    {
        ApiClient.GetAPI(url: urlForJson) { (success, dictData) in
            if success == false{
                Utils.showAlert(title: "Error", Message: "Error while fetching data from \(urlForJson)", buttonText: "Ok", viewController: self)
            }else{
                self.arrayData.removeAll()
                if let  array = dictData["rows"] as? [[String:AnyObject]]{
                    for dict in array{
                        self.arrayData.append(FactDataModel(dictInfo: dict))
                    }
                }
                DispatchQueue.main.async
                    {
                        if let  title = dictData["title"] as? String{
                            self.title = title
                        }
                        self.pullToRefresh.endRefreshing()
                        self.mainTableView.reloadData()
                }
            }
        }
    }

}

// MARK: - For API Call

extension ViewController
{
    // Mark :- Datasource Methods For Table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrayData.count == 0) ? 1 : self.arrayData.count
    }
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let range = Range(uncheckedBounds: (lower: 0, upper: self.mainTableView.numberOfSections))
        self.mainTableView.reloadSections(IndexSet(integersIn: range), with: .none)
        // use as? or as! to cast UITableViewCell to your desired type
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier =  "FactDataCell"
        var cell =  tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)
        }
        if(self.arrayData.count == 0){
                cell?.detailTextLabel?.text = "\"Pull to Refresh\"  Or Tap On Refresh icon to load data from server."
        }else{
            let fact =  arrayData[indexPath.row]
            cell?.textLabel?.text = fact.title.trimmingCharacters(in: .whitespacesAndNewlines)
            cell?.detailTextLabel?.text = fact.details.trimmingCharacters(in: .whitespacesAndNewlines)
            cell?.imageView?.image = nil
            if(fact.imageUrl.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
                let imageUrl = URL(string:fact.imageUrl.trimmingCharacters(in: .whitespacesAndNewlines))
                cell?.imageView?.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                    if image != nil {
                        cell?.imageView?.image = Utils.resizeImage(with: image, scaledTo: (Utils.deviceType() == .iPhone) ? CGSize(width: 45.0, height: 45.0) : CGSize(width: 100.0, height: 100.0))
                    }
                    cell?.layoutIfNeeded()
                    cell?.layoutSubviews()
                    cell?.setNeedsLayout()
                })
            }
        }
        return cell!;
    }

}
