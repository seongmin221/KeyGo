//
//  SetupEndPoint.swift
//  Maddori.Apple
//
//  Created by Mingwan Choi on 2022/11/16.
//

import Alamofire

enum SetupEndPoint<T: Encodable> {
    case dispatchlogin(T)
    case dispatchCreateTeam(T, userId: String)
    case dispatchJoinTeam(T, userId: String)
    
    var address: String {
        switch self {
        case .dispatchlogin:
            return "\(UrlLiteral.baseUrl)/users/login"
        case .dispatchCreateTeam:
            return "\(UrlLiteral.baseUrl)/teams"
        case .dispatchJoinTeam:
            return "\(UrlLiteral.baseUrl)/users/join-team"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .dispatchlogin:
            return .post
        case .dispatchCreateTeam:
            return .post
        case .dispatchJoinTeam:
            return .post
        }
    }
    
    var body: T? {
        switch self {
        case .dispatchlogin(let body):
            return body
        case .dispatchCreateTeam(let body, _):
            return body
        case .dispatchJoinTeam(let body, _):
            return body
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .dispatchlogin:
            return nil
        case .dispatchCreateTeam(_, let userId):
            let headers = ["user_id": userId]
            return HTTPHeaders(headers)
        case .dispatchJoinTeam(_, let userId):
            let headers = ["user_id": userId]
            return HTTPHeaders(headers)
        }
    }
}
