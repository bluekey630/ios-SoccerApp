//
//  BaLiveDataParser.swift
//  bahisadam
//
//  Created by ilker özcan on 09/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

public struct LiveData {
	
	public let sectionCount: Int
	public let rowCounts: [Int]
	public let allLeagueData: [BA_Leagues]
}

public func ConfigureLiveData(data: Dictionary<String, AnyObject>) -> LiveData {
	var leagues: [BA_Leagues] = [BA_Leagues]()
	
	for leagueObject in data {
		
		if let league = leagueObject.value as? Dictionary<String, AnyObject> {
			
			let leagueId = league["id"] as? Int ?? 0
			let leagueOrder = league["order"] as? Int ?? 0
			let leagueName = league["league_name_tr"] as? String ?? ""
			let leagueFlag = league["flag"] as? String ?? ""
			
			var newLeague = BA_Leagues(leagueName: leagueName, leagueId: leagueId, leagueOrder: leagueOrder, customLogo: leagueFlag)
			
			if let matches = league["matches"] as? [Dictionary<String, AnyObject>] {
				
				for match in matches {
					
					let homeTeamData: BA_Team
					if let homeTeam = match["home_team"] as? Dictionary<String, AnyObject> {
						
						let teamName: String
						if let teamNameTr = homeTeam["team_name_tr"] as? String {
							
							teamName = teamNameTr
						}else{
							teamName = homeTeam["team_name"] as? String ?? ""
						}
						let teamId = homeTeam["id"] as? Int ?? 0
						let color1 = homeTeam["color1"] as? String ?? ""
						let color2 = homeTeam["color2"] as? String ?? ""
						
						homeTeamData = BA_Team(teamName: teamName, teamId: teamId, color1: color1, color2: color2)
						
					}else{
						homeTeamData = BA_Team(teamName: "", teamId: 0, color1: "", color2: "")
					}
					
					let awayTeamData: BA_Team
					if let awayTeam = match["away_team"] as? Dictionary<String, AnyObject> {
						
						let teamName: String
						if let teamNameTr = awayTeam["team_name_tr"] as? String {
							
							teamName = teamNameTr
						}else{
							teamName = awayTeam["team_name"] as? String ?? ""
						}
						let teamId = awayTeam["id"] as? Int ?? 0
						let color1 = awayTeam["color1"] as? String ?? ""
						let color2 = awayTeam["color2"] as? String ?? ""
						
						awayTeamData = BA_Team(teamName: teamName, teamId: teamId, color1: color1, color2: color2)
						
					}else{
						awayTeamData = BA_Team(teamName: "", teamId: 0, color1: "", color2: "")
					}
					
					let currentMinutes: String
					if let currentMinuteStr = match["live_minute"] as? String {
						
						currentMinutes = currentMinuteStr
						
					}else if let currentMinuteInt = match["live_minute"] as? Int {
						
						currentMinutes = "\(currentMinuteInt)"
					}else{
						currentMinutes = "Des"
					}
					
					let resultType: String
					let status = match["status"] as? Int ?? 0
					if(status == 1) {
						
						resultType = "Played"
					}else{
						
						if(currentMinutes != "Des") {
							
							resultType = "Playing"
						}else{
							resultType = "Played"
						}
					}
					let result = match["result"] as? String ?? "0-0"
					let splittedResult = result.components(separatedBy: "-")
					let matchId = match["_id"] as? String ?? ""
					let matchYear = match["year"] as? Int ?? 2017
					let homeGoal = Int(splittedResult[0]) ?? 0
					let awayGoal = Int(splittedResult[1]) ?? 0
					
					let matchData = BA_Matc(homeTeam: homeTeamData, awayTeam: awayTeamData, resultType: resultType, homeGoals: homeGoal, awayGoals: awayGoal, matchId: matchId, matchYear: matchYear, currentMinutes: currentMinutes)
					
					newLeague.addMatch(match: matchData)
				}
			}
			
			leagues.append(newLeague)
			
		}
	}
	
	let allLeagueData = leagues.sorted { (d1, d2) -> Bool in
		
		if(d1.leagueOrder < d2.leagueOrder) {
			return true
		}else{
			return false
		}
	}
	
	let sectionCount = allLeagueData.count
	var rowCounts = [Int]()
	
	for leagueData in allLeagueData {
		
		rowCounts.append(leagueData.matches.count)
	}
	
	return LiveData(sectionCount: sectionCount, rowCounts: rowCounts, allLeagueData: allLeagueData)
}
