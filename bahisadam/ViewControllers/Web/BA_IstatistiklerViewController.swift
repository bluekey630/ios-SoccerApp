//
//  BA_IstatistiklerViewController.swift
//  bahisadam
//
//  Created by bluekey on 3/25/17.
//  Copyright © 2017 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive
import MBProgressHUD

class BA_IstatistiklerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var skartButton: UIButton!
    @IBOutlet weak var kkartButton: UIButton!
    @IBOutlet weak var asistButton: UIButton!
    @IBOutlet weak var golButton: UIButton!
    
    @IBOutlet weak var selGolView: UIView!
    @IBOutlet weak var selAsistView: UIView!
    @IBOutlet weak var selKKartView: UIView!
    @IBOutlet weak var selSKartView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var containerView: UIView!

//    let leagueIconUrl = "http://static.bahisadam.com/images/logo/teams/%d_logo.png"
  
    let loadDataUrl = "http://www.bahisadam.com/api/stats/byLeague/%d"
//
    private var goalsData:NSArray?
    private var asistsData:NSArray?
    private var kkartData:NSArray?
    private var skartData:NSArray?

    @IBOutlet weak var titleLabel: UILabel!
    var leagueID:Int!
    var state = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.layer.cornerRadius = 5
        self.containerView.clipsToBounds = true;
        
        golButton.isEnabled = false
        selGolView.isHidden = false

        asistButton.isEnabled = true
        selAsistView.isHidden = true
        
        kkartButton.isEnabled = true
        selKKartView.isHidden = true
        
        skartButton.isEnabled = true
        selSKartView.isHidden = true
        
        state = 0
        //self.loadData()
        
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
                
                if let dataArry = data as? NSDictionary {
                    self.goalsData = dataArry["goals"] as? NSArray
                    self.asistsData = dataArry["asists"] as? NSArray
                    self.kkartData = dataArry["red_cards"] as? NSArray
                    self.skartData = dataArry["yellow_cards"] as? NSArray
                    
                    self.tableView.reloadData();
                    
                }
                
                MBProgressHUD.hideAllHUDs(for: self.view, animated: false)
            }
        })
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if state == 0 {
            if (self.goalsData != nil) {
                return self.goalsData!.count
            }
            
        }
        else if state == 1 {
            if (self.asistsData != nil) {
                return self.asistsData!.count
            }
            
        }
        else if state == 2 {
            if (self.kkartData != nil) {
                return self.kkartData!.count
            }
            
        }
        else if state == 3 {
            if (self.skartData != nil) {
                return self.skartData!.count
            }
            
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BA_IstatistiklerTableViewCell", for: indexPath) as! BA_IstatistiklerTableViewCell
        if state == 0 {
            self.titleLabel.text = "Gol Krallığı"
            cell.playerImage.image = nil
            let buf = self.goalsData?[indexPath.row] as? NSDictionary
            let playerUrl = buf?["player_image"] as? String
            UIImage.getWebImage(imageUrl: playerUrl!) { (responseImage) in
                
                cell.playerImage.image = responseImage
            }
            cell.playerName.text = buf?["nick"] as! String?
            cell.teamImage.image = nil
            let teamUrl = buf?["team_shield"]
            UIImage.getWebImage(imageUrl: teamUrl as! String) { (responseImage) in
                
                cell.teamImage.image = responseImage
            }
            
            cell.teamName.text = buf?["team_name"] as! String?
            cell.countLabel.text = buf?["total"] as! String?
            
        }
        else if state == 1 {
            self.titleLabel.text = "Asist Krallığı"
            cell.playerImage.image = nil
            let buf = self.asistsData?[indexPath.row] as? NSDictionary
            let playerUrl = buf?["player_image"]
            UIImage.getWebImage(imageUrl: playerUrl as! String) { (responseImage) in
                
                cell.playerImage.image = responseImage
            }
            cell.playerName.text = buf?["nick"] as! String?
            cell.teamImage.image = nil
            let teamUrl = buf?["team_shield"]
            UIImage.getWebImage(imageUrl: teamUrl as! String) { (responseImage) in
                
                cell.teamImage.image = responseImage
            }
            
            cell.teamName.text = buf?["team_name"] as! String?
            cell.countLabel.text = buf?["total"] as! String?
        }
        else if state == 2 {
            self.titleLabel.text = "Kırmızı Kart"
            cell.playerImage.image = nil
            let buf = self.kkartData?[indexPath.row] as? NSDictionary
            let playerUrl = buf?["player_image"]
            UIImage.getWebImage(imageUrl: playerUrl as! String) { (responseImage) in
                
                cell.playerImage.image = responseImage
            }
            cell.playerName.text = buf?["nick"] as! String?
            cell.teamImage.image = nil
            let teamUrl = buf?["team_shield"]
            UIImage.getWebImage(imageUrl: teamUrl as! String) { (responseImage) in
                
                cell.teamImage.image = responseImage
            }
            
            cell.teamName.text = buf?["team_name"] as! String?
            cell.countLabel.text = buf?["total"] as! String?
        }
        else if state == 3 {
            self.titleLabel.text = "Sarı Kart"
            cell.playerImage.image = nil
            let buf = self.skartData?[indexPath.row] as? NSDictionary
            let playerUrl = buf?["player_image"]
            UIImage.getWebImage(imageUrl: playerUrl as! String) { (responseImage) in
                
                cell.playerImage.image = responseImage
            }
            cell.playerName.text = buf?["nick"] as! String?
            cell.teamImage.image = nil
            let teamUrl = buf?["team_shield"]
            UIImage.getWebImage(imageUrl: teamUrl as! String) { (responseImage) in
                
                cell.teamImage.image = responseImage
            }
            
            cell.teamName.text = buf?["team_name"] as! String?
            cell.countLabel.text = buf?["total"] as! String?
        }

        return cell
        
    }
    
    @IBAction func golTapped(_ sender: Any) {
        
        state = 0
        tableView.reloadData()
        golButton.isEnabled = false
        selGolView.isHidden = false
        
        asistButton.isEnabled = true
        selAsistView.isHidden = true
        
        kkartButton.isEnabled = true
        selKKartView.isHidden = true
        
        skartButton.isEnabled = true
        selSKartView.isHidden = true
    }
    
    @IBAction func asistTapped(_ sender: Any) {
        
        state = 1
        tableView.reloadData()
        golButton.isEnabled = true
        selGolView.isHidden = true
        
        asistButton.isEnabled = false
        selAsistView.isHidden = false
        
        kkartButton.isEnabled = true
        selKKartView.isHidden = true
        
        skartButton.isEnabled = true
        selSKartView.isHidden = true
    }
    
    @IBAction func kkartTapped(_ sender: Any) {
        
        state = 2
        tableView.reloadData()
        golButton.isEnabled = true
        selGolView.isHidden = true
        
        asistButton.isEnabled = true
        selAsistView.isHidden = true
        
        kkartButton.isEnabled = false
        selKKartView.isHidden = false
        
        skartButton.isEnabled = true
        selSKartView.isHidden = true
    }
    
    @IBAction func skartTapped(_ sender: Any) {
        
        state = 3
        tableView.reloadData()
        golButton.isEnabled = true
        selGolView.isHidden = true
        
        asistButton.isEnabled = true
        selAsistView.isHidden = true
        
        kkartButton.isEnabled = true
        selKKartView.isHidden = true
        
        skartButton.isEnabled = false
        selSKartView.isHidden = false
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
