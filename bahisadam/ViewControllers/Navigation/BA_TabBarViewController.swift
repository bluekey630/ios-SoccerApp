//
//  BA_TabBarViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 26/09/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive

class BA_TabBarViewController: UITabBarController, UIPopoverPresentationControllerDelegate {

	fileprivate let webviewIdx = 5
	private var currentRegion: String = "tr"
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		if let region = IO_Helpers.deviceLocale {
			
			self.currentRegion = region
			if(self.currentRegion == "az") {
				
				if let currentTabBarLastTabImage = self.tabBar.items?[4] {
					
					currentTabBarLastTabImage.image = UIImage(named: "league_logo_az")
					currentTabBarLastTabImage.selectedImage = UIImage(named: "league_logo_az")
				}
			}
		}
        
        NotificationCenter.default.addObserver(self, selector: #selector(BA_TabBarViewController.userStateChanged(notification:)), name: NSNotification.Name(rawValue: "UserStateChanged"), object: nil)
		
    }

    func userStateChanged(notification: Notification) {
        
        // if device logged in we need to change 4th tab
        if (BA_AppDelegate.Ba_LoginData?.IsDeviceLogin)! {
            var tabs = viewControllers
            let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BA_MatchesMainViewController") as! BA_MatchesMainViewController
            controller.favoritesState = true
            tabs?[3] = controller
            viewControllers = tabs
            
            // changing tab bar icon and title
            if let item = tabBar.items?[3] {
                item.title = "Favorilerim"
                item.image = UIImage(named: "star-o")
                item.selectedImage = UIImage(named: "star")
            }
        }
    }

	
    // MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using [segue destinationViewController].
		// Pass the selected object to the new view controller.
		
		if let segueId = segue.identifier {
			
			if (segueId == "sg_ba_news_popup") {
				
				if let popoverViewController = segue.destination as? BA_NewsViewTableViewController {
					
					popoverViewController.modalPresentationStyle = .popover
					popoverViewController.popoverPresentationController!.delegate = self
				}
			}
		}
	}
	
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		
		return UIModalPresentationStyle.none
	}

	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		
		if(item.tag == webviewIdx) {
			
			if let baNavController =  self.navigationController as? BA_NavigationController {
				
				if let loadedWebviewRef = baNavController.getLoadedWebview() {
					
					if let webViewVC = self.viewControllers?.last as? BA_WebContainerViewController {
						
						if(currentRegion == "az") {
                            
                            BA_Database.SharedInstance.getCountryList { (status, data, error, statusCode) in
                                
                                if(status) {
                                    
                                    let allCountries = data as? [BA_Countries]
                                    for country in allCountries!{
                                        if self.currentRegion == country.countryCode {
                                            webViewVC.league = country.leagues.first
                                            webViewVC.embedWebview(webViewRef: loadedWebviewRef, url: BA_Server.PointsApi_AZ, displayTabBar: false)
                                            self.navigationItem.title = "Azerbeycan Premier Lig"
                                            break
                                        }
                                    }
                                    
                                    
                                }
                            }

							
							
						}else{
                            BA_Database.SharedInstance.getCountryList { (status, data, error, statusCode) in
                                
                                if(status) {
                                    
                                    let allCountries = data as? [BA_Countries]
                                    for country in allCountries!{
                                        if "tr" == country.countryCode {
                                            webViewVC.league = country.leagues.first
                                            webViewVC.embedWebview(webViewRef: loadedWebviewRef, url: BA_Server.PointsApi_AZ, displayTabBar: false)
                                            self.navigationItem.title = "Türkiye Süper Ligi"
                                            break
                                        }
                                    }
                                }
                            }

//							webViewVC.embedWebview(webViewRef: loadedWebviewRef, url: BA_Server.PointsApi, displayTabBar: false)
//							self.navigationItem.title = "Türkiye Süper Ligi"
						}
					}
				}
			}
		}
	}
	
	
}
