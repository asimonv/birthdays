//
//  HomeDelegate.swift
//  Birthdays
//
//  Created by Andre Simon on 30-01-21.
//

import Foundation

protocol BirthdayDelegate: class {
    func newBirthdayAdded(_ birthday : Birthday)
}
