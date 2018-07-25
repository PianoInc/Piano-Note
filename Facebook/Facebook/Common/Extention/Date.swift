//
//  Date.swift
//  Facebook
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

internal extension Date {
    
    /**
     규칙에 따르는 string을 반환한다.
     
     오늘, 어제, 최근 일주일, 최근 한달, %d개월 전, %d년 %d월
     */
    internal var group: String {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: self)
        
        var todayComponents = calendar.dateComponents([.year, .month, .day, .hour], from: Date())
        todayComponents.hour = 0
        todayComponents.minute = 0
        let today = calendar.date(from: todayComponents)!
        
        let interval = calendar.dateComponents([.year, .month, .day, .hour], from: self, to: today)
        if interval.year! > 0 {
            return String(format: "yearPast".loc, components.year!, components.month!)
        } else if interval.month! > 0 {
            return String(format: "inYear".loc, interval.month!)
        } else if interval.day! > 6 {
            return "recentMonth".loc
        } else if interval.day! > 0 {
            return "recentWeek".loc
        } else if interval.hour! > 0 {
            return "yesterday".loc
        } else {
            return "today".loc
        }
    }
    
}
