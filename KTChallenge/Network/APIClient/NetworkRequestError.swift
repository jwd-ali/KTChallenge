//
//  AppError.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//

import Foundation
enum NetworkRequestError: Error {
    case unknown
    case requestError
    case notConnected
    case serverError(error: String)
}
