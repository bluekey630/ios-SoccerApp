//
//  BA_PDrumuViewController.swift
//  bahisadam
//
//  Created by bluekey on 3/24/17.
//  Copyright © 2017 ilkerozcan. All rights reserved.
//http://static.bahisadam.com/images/logo/teams/\(self.teamId)_logo.png
import UIKit
import BahisadamLive
import MBProgressHUD

class BA_PDromuViewController: UIViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var genelButton: UIButton!
    @IBOutlet weak var icSahaButton: UIButton!
    @IBOutlet weak var disSahaButton: UIButton!
    @IBOutlet weak var genelSelView: UIView!
    @IBOutlet weak var icSahaSelView: UIView!
    @IBOutlet weak var disSahaSelView: UIView!
   
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let leagueIconUrl = "http://static.bahisadam.com/images/logo/teams/%d_logo.png"
    let loadDataUrl = "http://www.bahisadam.com/api/league/standings/%d"
    
    private var standingData:NSArray?
    private var homeData:NSArray?
    private var awayData:NSArray?
    
    var leagueID:Int!
    var state = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.layer.cornerRadius = 5        
        self.containerView.clipsToBounds = true;

        genelButton.isEnabled = false
        genelSelView.isHidden = false
        
        icSahaButton.isEnabled = true
        icSahaSelView.isHidden = true
        
        disSahaButton.isEnabled = true
        disSahaSelView.isHidden = true
        state = 0
        self.loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        MBProgressHUD.showAdded(to: self.view, animated: false)
        let url = String(format: loadDataUrl, leagueID!)
        
        IO_NetworkHelper(getJSONRequest: url, completitionHandler: {(status, data, error, statusCode) in
        
            if(status) {
                
                if let dataArry = data as? NSArray {
                    let standDict = dataArry[0] as! NSDictionary
                    let standGroups = standDict["groups"] as? NSArray
                    
                    let standBuffer = standGroups?[0] as? NSDictionary
                    self.standingData = standBuffer?["team_standings"] as? NSArray
                    
                    
                    let homeDict = dataArry[1] as! NSDictionary
                    
                    let homeGroups = homeDict["groups"] as? NSArray
                    
                    let homeBuffer = homeGroups?[0] as? NSDictionary
                    self.homeData = homeBuffer?["team_standings"] as? NSArray
                    
                    let awayDict = dataArry[2] as! NSDictionary
                    
                    let awayGroups = awayDict["groups"] as? NSArray
                    
                    let awayBuffer = awayGroups?[0] as? NSDictionary
                    self.awayData = awayBuffer?["team_standings"] as? NSArray
                    
                    self.tableView.reloadData();

                }
                
                MBProgressHUD.hideAllHUDs(for: self.view, animated: false)
            }
        })
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if state == 0 {
            if (self.standingData != nil) {
                return self.standingData!.count
            }
            
        }
        else if state == 1 {
            if (self.homeData != nil) {
                return self.homeData!.count
            }
            
        }
        else if state == 2 {
            if (self.awayData != nil) {
                return self.awayData!.count
            }
            
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "BA_PDrumuTableViewCell", for: indexPath) as! BA_PDrumuTableViewCell
        if state == 0 {
            cell.posLabel.text = (indexPath.row + 1 as NSNumber).stringValue
            let buf = self.standingData?[indexPath.row] as? NSDictionary
            cell.leagueName.text = buf?["team_name"] as? String
            cell.omLabel.text = (buf?["OM"] as! NSNumber).stringValue
            cell.gLabel.text = (buf?["G"] as! NSNumber).stringValue
            cell.bLabel.text = (buf?["B"] as! NSNumber).stringValue
            cell.mLabel.text = (buf?["M"] as! NSNumber).stringValue
            cell.ptsLabel.text = (buf?["PTS"] as! NSNumber).stringValue
            
            cell.leagueImage.image = nil
            let url = String(format: leagueIconUrl, buf?["_id"] as! Int)
            UIImage.getWebImage(imageUrl: url) { (responseImage) in
                
                cell.leagueImage.image = responseImage
            }
            
        }
        else if state == 1 {
            cell.posLabel.text = (indexPath.row + 1 as NSNumber).stringValue
            let buf = self.homeData?[indexPath.row] as? NSDictionary
            cell.leagueName.text = buf?["team_name"] as? String
            cell.omLabel.text = (buf?["OM"] as! NSNumber).stringValue
            cell.gLabel.text = (buf?["G"] as! NSNumber).stringValue
            cell.bLabel.text = (buf?["B"] as! NSNumber).stringValue
            cell.mLabel.text = (buf?["M"] as! NSNumber).stringValue
            cell.ptsLabel.text = (buf?["PTS"] as! NSNumber).stringValue
            
            cell.leagueImage.image = nil
            let url = String(format: leagueIconUrl, buf?["_id"] as! Int)
            UIImage.getWebImage(imageUrl: url) { (responseImage) in
                
                cell.leagueImage.image = responseImage
            }

        }
        else if state == 2 {
            cell.posLabel.text = (indexPath.row + 1 as NSNumber).stringValue
            let buf = self.awayData?[indexPath.row] as? NSDictionary
            cell.leagueName.text = buf?["team_name"] as? String
            cell.omLabel.text = (buf?["OM"] as! NSNumber).stringValue
            cell.gLabel.text = (buf?["G"] as! NSNumber).stringValue
            cell.bLabel.text = (buf?["B"] as! NSNumber).stringValue
            cell.mLabel.text = (buf?["M"] as! NSNumber).stringValue
            cell.ptsLabel.text = (buf?["PTS"] as! NSNumber).stringValue
            
            cell.leagueImage.image = nil
            let url = String(format: leagueIconUrl, buf?["_id"] as! Int)
            UIImage.getWebImage(imageUrl: url) { (responseImage) in
                
                cell.leagueImage.image = responseImage
            }

        }
       return cell
       
    }
    
    @IBAction func genelTapped(_ sender: Any) {
        state = 0
        tableView.reloadData()
        genelButton.isEnabled = false
        genelSelView.isHidden = false
        
        icSahaButton.isEnabled = true
        icSahaSelView.isHidden = true
        
        disSahaButton.isEnabled = true
        disSahaSelView.isHidden = true
    }
   
    
    @IBAction func icSahaTapped(_ sender: Any) {
        state = 1
        tableView.reloadData()
        genelButton.isEnabled = true
        genelSelView.isHidden = true
        
        icSahaButton.isEnabled = false
        icSahaSelView.isHidden = false
        
        disSahaButton.isEnabled = true
        disSahaSelView.isHidden = true
    }
    
    @IBAction func disSahaTapped(_ sender: Any) {
        state = 2
        tableView.reloadData()
        genelButton.isEnabled = true
        genelSelView.isHidden = true
        
        icSahaButton.isEnabled = true
        icSahaSelView.isHidden = true
        
        disSahaButton.isEnabled = false
        disSahaSelView.isHidden = false
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


