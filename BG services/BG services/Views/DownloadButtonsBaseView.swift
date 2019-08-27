//
//  DownloadButtonsBaseView.swift
//  BG services
//
//  Created by Karthik on 08/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit

enum DownloadButtonsViewStyle: Int {
    case download, downloading, downloaded
}



class DownloadButtonsBaseView: UIView {
    var style = DownloadButtonsViewStyle.download
    
    init() {
        self.style = .download
        super.init(frame: CGRect.zero)
        
        setupViews()
    }
    
    required init(style: DownloadButtonsViewStyle) {
        self.style = style
        super.init(frame: CGRect.zero)
        
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    func setupViews() {
        
    }
}
