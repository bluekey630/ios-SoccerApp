//
//  BA_FiksturViewController.swift
//  bahisadam
//
//  Created by bluekey on 3/25/17.
//  Copyright © 2017 ilkerozcan. All rights reserved.
//
//
import UIKit
import BahisadamLive
import MBProgressHUD

class BA_FiksturViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    
    let loadDataUrl = "http://www.bahisadam.com/api/fixture/%d"
    let curUrl = "http://www.bahisadam.com/api/fixture/%d/%d"
    let leagueIconUrl = "http://static.bahisadam.com/images/logo/teams/%d_logo.png"
    let month_mask = ["Oca","Şub","Mar","Nis","May","Haz","Tem","Ağu","Eyl","Eki","Kas","Ara"]
    var curRound = 0
    var totalRound = 0
    private var matchesArray:NSArray?
    //    private var homeData:NSArray?
    //    private var awayData:NSArray?
    //
    var leagueID:Int!
    var state = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.layer.cornerRadius = 5
        self.containerView.clipsToBounds = true;
        //        genelButton.isEnabled = false
        //        genelSelView.isHidden = false
        //
        //        icSahaButton.isEnabled = true
        //        icSahaSelView.isHidden = true
        //
        //        disSahaButton.isEnabled = true
        //        disSahaSelView.isHidden = true
        state = 0
        curRound = 0
        totalRound = 0
        //self.loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = String(format: loadDataUrl, leagueID!)
        self.loadData(url: url)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(url:String) {
        MBProgressHUD.showAdded(to: self.view, animated: false)
        //let url = String(format: u, leagueID!)
        
        IO_NetworkHelper(getJSONRequest: url, completitionHandler: {(status, data, error, statusCode) in
        
            if(status) {
        
                if let dataArry = data as? NSDictionary {
                    let leagueStatus = dataArry["leagueStatus"] as? NSDictionary
                    if ((leagueStatus?["total_rounds"] as? Int) != nil) {
                        self.totalRound = (leagueStatus?["total_rounds"] as? Int)!
                    }
                    else{
                        self.totalRound = 0
                    }
                    
                    self.curRound = (leagueStatus?["round"] as? Int)!
                    self.titleLabel.text = String(format: "%d.ROUND", self.curRound)
                    let groups = dataArry["groups"] as? NSArray
                    if (groups?.count)! > 0 {
                        let groupsDict = groups?[0] as? NSDictionary
                        self.matchesArray = groupsDict?["matches"] as? NSArray
                    }
                    
                    
                   // print(leagueStatus!)
                   // print(groups!)
//                    let standDict = dataArry[0] as! NSDictionary
//                    let standGroups = standDict["groups"] as? NSArray
                    self.tableView.reloadData();
        
                }
        
                MBProgressHUD.hideAllHUDs(for: self.view, animated: false)
            }
       })
    }
    
    
    @IBAction func rightTapped(_ sender: Any) {
        
        if curRound < totalRound {
            curRound += 1
            let url = String(format:curUrl, leagueID, curRound)
            loadData(url : url)
        }
        else if curRound == totalRound {
            return
        }
        else {
            curRound = totalRound
            if curRound == 0 {
                curRound = 1
            }
            let url = String(format:curUrl, leagueID, curRound)
            loadData(url : url)
        }
        
    }
    
    @IBAction func leftTapped(_ sender: Any) {
        if curRound > 1 {
            curRound -= 1
            let url = String(format:curUrl, leagueID, curRound)
            loadData(url : url)
            
        }
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (self.matchesArray != nil){
            return self.matchesArray!.count
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BA_FiksturTableViewCell", for: indexPath) as! BA_FiksturTableViewCell
                //cell.infoLabel.text =
        let bufMain = self.matchesArray?[indexPath.row] as? NSDictionary
        let bufHome = bufMain?["home_team"] as? NSDictionary
        let bufAway = bufMain?["away_team"] as? NSDictionary
        
        cell.teamName1.text = bufHome?["team_name"] as? String
        cell.teamName2.text = bufAway?["team_name"] as? String
        
        cell.teamImage1.image = nil
        let urlHome = String(format: leagueIconUrl, bufHome?["_id"] as! Int)
        UIImage.getWebImage(imageUrl: urlHome) { (responseImage) in
            cell.teamImage1.image = responseImage
        }
        
        cell.teamImage2.image = nil
        let urlAway = String(format: leagueIconUrl, bufAway?["_id"] as! Int)
        UIImage.getWebImage(imageUrl: urlAway) { (responseImage) in
            cell.teamImage2.image = responseImage
        }
        
        let home_goals = bufMain?["home_goals"] as? Int
        let away_goals = bufMain?["away_goals"] as? Int
        
        if home_goals != nil {
            
            let info = String(format:"%d:%d", home_goals!, away_goals!)
            cell.infoLabel.text = info
            cell.infoConstrain.constant = 40
            //cell.infoLabel.frame.size.width = 60
        }
        else
        {
            let strTime = bufMain?["match_date"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from:strTime)!
            
            let calendar = Calendar.current
            
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            //let info = self.month_mask[month-1]+" "+day+","+hour+":"+minute
            let info = String(format : "%@ %d, %02d:%02d", self.month_mask[month-1], day, hour, minute)
            cell.infoLabel.text = info
            cell.infoConstrain.constant = 80
            //cell.infoLabel.frame.size.width = 80
        }
        
        
        
        
                //            ce..cell.posLabel.text = (indexPath.row + 1 as NSNumber).stringValue
//            let buf = self.standingData?[indexPath.row] as? NSDictionary
//            cell.leagueName.text = buf?["team_name"] as? String
//            cell.omLabel.text = (buf?["OM"] as! NSNumber).stringValue
//            cell.gLabel.text = (buf?["G"] as! NSNumber).stringValue
//            cell.bLabel.text = (buf?["B"] as! NSNumber).stringValue
//            cell.mLabel.text = (buf?["M"] as! NSNumber).stringValue
//            cell.ptsLabel.text = (buf?["PTS"] as! NSNumber).stringValue
//        
        
        return cell
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
