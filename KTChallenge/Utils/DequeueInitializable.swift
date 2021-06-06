//
//  DequeueInitializable.swift
//  WeatherExercise
//
//  Created by Jawad Ali on 20/10/2020.
//  Copyright © 2020 Jawad Ali. All rights reserved.
//

import Foundation
import UIKit

// MARK: Reusable view
public protocol ReusableView: class {}

public extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
