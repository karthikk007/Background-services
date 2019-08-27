//
//  BaseCell.swift
//  BG services
//
//  Created by Karthik on 07/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation
import UIKit

protocol Identifiable {
    static var identifier: String { get }
}

class BaseCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {

    }
}

extension BaseCell: Identifiable {
    static var identifier: String {
        return "cellIdentifier"
    }
}
