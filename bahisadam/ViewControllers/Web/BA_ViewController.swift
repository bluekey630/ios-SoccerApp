//
//  BA_ViewController.swift
//  bahisadam
//
//  Created by bluekey on 3/23/17.
//  Copyright © 2017 ilkerozcan. All rights reserved.


import UIKit
import BahisadamLive

class BA_ViewController: UIViewController {
    
    @IBOutlet weak var istatistiklerButton: UIButton!
    @IBOutlet weak var selPDurumuView: UIView!
    @IBOutlet weak var fiksturButton: UIButton!
    @IBOutlet weak var selFiksturView: UIView!
    @IBOutlet weak var pdurumuButton: UIButton!
    @IBOutlet weak var selIstatistiklerView: UIView!
    
    @IBOutlet weak var imgLeague: UIImageView!
    @IBOutlet weak var leagueName: UILabel!
    var league: BA_Leagues!
    
    @IBOutlet var containerView: UIView!
    
    private var containerViewController: UIViewController?
    private var currentVC: UIViewController?
    
    var state = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        istatistiklerButton.isEnabled = false;
        selIstatistiklerView.isHidden = false;
        fiksturButton.isEnabled = true;
        selFiksturView.isHidden = true;
        pdurumuButton.isEnabled = true;
        selPDurumuView.isHidden = true;
        state = 0
        
        self.imgLeague.layer.cornerRadius = self.imgLeague.frame.size.width / 2
        
        self.imgLeague.clipsToBounds = true;
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        leagueName.text = league.leagueName
        
        self.imgLeague.image = nil
        UIImage.getWebImage(imageUrl: league.logoUrl) { (responseImage) in
            
            self.imgLeague.image = responseImage
        }
        
        loadViewController(state: state)
        
    }
    
    func loadViewController(state : Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if state == 0 {
            currentVC = storyboard.instantiateViewController(withIdentifier: "BA_IstatistiklerViewController")
            if currentVC != nil {
                embedViewController(viewController: currentVC!)
            }
        }
        else if state == 1 {
            currentVC = storyboard.instantiateViewController(withIdentifier: "BA_FiksturViewController")
            if currentVC != nil {
                embedViewController(viewController: currentVC!)
            }
        }
        else if state == 2 {
            currentVC = storyboard.instantiateViewController(withIdentifier: "BA_PDrumuViewController")
            if currentVC != nil {
                embedViewController(viewController: currentVC!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func tapIstatistikler(_ sender: Any) {
        state = 0
        istatistiklerButton.isEnabled = false;
        selIstatistiklerView.isHidden = false;
        fiksturButton.isEnabled = true;
        selFiksturView.isHidden = true;
        pdurumuButton.isEnabled = true;
        selPDurumuView.isHidden = true;
        loadViewController(state : state)
    }

    @IBAction func tapFikstur(_ sender: Any) {
        state = 1
        istatistiklerButton.isEnabled = true;
        selIstatistiklerView.isHidden = true;
        fiksturButton.isEnabled = false;
        selFiksturView.isHidden = false;
        pdurumuButton.isEnabled = true;
        selPDurumuView.isHidden = true;
        loadViewController(state : state)
    }
    
    @IBAction func tapPDurumu(_ sender: Any) {
        state = 2
        istatistiklerButton.isEnabled = true;
        selIstatistiklerView.isHidden = true;
        fiksturButton.isEnabled = true;
        selFiksturView.isHidden = true;
        pdurumuButton.isEnabled = false;
        selPDurumuView.isHidden = false;
        loadViewController(state : state)
    }
    
    func embedViewController(viewController: UIViewController) {
        
        
        if String(describing: type(of: viewController)) == "BA_PDromuViewController" {
            (viewController as! BA_PDromuViewController).leagueID = league.leagueId
        }
        else if String(describing: type(of: viewController)) == "BA_FiksturViewController" {
            (viewController as! BA_FiksturViewController).leagueID = league.leagueId
        }
        else if String(describing: type(of: viewController)) == "BA_IstatistiklerViewController" {
            (viewController as! BA_IstatistiklerViewController).leagueID = league.leagueId
        }

        viewController.willMove(toParentViewController: self)
        containerView.addSubview(viewController.view)
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        self.containerViewController = viewController
        viewController.view.frame = self.containerView.bounds
        viewController.view.layoutIfNeeded()
       
    }
    
    func loadUrl(url: String) {
        
        print(url)
        
//        if(self.view != nil) {
//            self.view.alpha = 0
//        }
//        
//        if(!self.pageLoaded) {
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150), execute: {
//                
//                self.loadUrl(url: url)
//            })
//        }else{
//            
//            self.webView?.evaluateJavaScript("window.showBlockUI();", completionHandler: { (response, error) in
//                
//                self.webView?.evaluateJavaScript("window.location.href = \"\(url)\"", completionHandler: { (response, error) in
//                    
//                    if(error != nil) {
//                        print("evaluateJavaScript \(error?.localizedDescription)")
//                    }else{
//                        
//                        if let backList = self.webView?.backForwardList.backList {
//                            
//                            self.lastBackItemIdx = backList.count
//                        }else{
//                            self.lastBackItemIdx = -1
//                        }
//                    }
//                    
//                })
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
//                    
//                    if(self.view != nil) {
//                        self.view.alpha = 1
//                    }
//                })
//            })
//        }
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

