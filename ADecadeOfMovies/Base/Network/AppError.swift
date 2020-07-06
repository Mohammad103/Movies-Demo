//
//  AppError.swift
//  ADecadeOfMovies
//
//  Created by Mohammad Shaker on 7/5/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import UIKit
import Moya

enum AppErrorCode: Int {
    case wrongCredentials  = 400
    case tokenExpired = 401
    case generalError = 0
}

struct AppError: Error {
    var errorCode: AppErrorCode = .generalError
    var serverErrorCode: Int?
    var errorMessage: String {
        return ErrorHandler.errorMesage(forErrorCode: errorCode)
    }
}

class ErrorHandler {
    class func errorMesage(forErrorCode error: AppErrorCode) -> String {
        switch error {
        case .wrongCredentials:
            return "Wrong Credentials"
        case .tokenExpired:
            return "Token Expired"
        default:
            return "General Error"
        }
    }
}
