//
//  BA_StatsDelegate.swift
//  bahisadam
//
//  Created by ilker özcan on 03/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import BahisadamLive
protocol BA_StatsDelegate {

	func expandCountry(countryId: Int)
	func leagueTapped(league: BA_Leagues)
}
