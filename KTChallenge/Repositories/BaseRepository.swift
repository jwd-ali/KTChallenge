//
//  BaseRepository.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//

import Foundation
class BaseRepository {
    public init() {}
    
    public lazy var searchService: SearchServiceType = {
        return SearchService()
    }()
}
