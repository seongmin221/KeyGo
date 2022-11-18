//
//  UserDefaultHandler.swift
//  Maddori.Apple
//
//  Created by Mingwan Choi on 2022/11/16.
//

import Foundation

struct UserDefaultHandler {
    static func clearAllData() {
        UserData<Any>.clearAll()
    }
    
    static func setIsLogin(isLogin: Bool) {
        UserData.setValue(isLogin, forKey: .isLogin)
    }
    
    static func setUserId(userId: Int) {
        UserData.setValue(userId, forKey: .userId)
    }
    
    static func setNickname(nickname: String) {
        UserData.setValue(nickname, forKey: .nickname)
    }
    
    static func setTeamId(teamId: Int) {
        UserData.setValue(teamId, forKey: .teamId)
    }
}
