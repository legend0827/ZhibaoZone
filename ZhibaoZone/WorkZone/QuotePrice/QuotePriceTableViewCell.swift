//
//  QuotePriceTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/5/30.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class QuotePriceTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - public
    public class func customCell(tableView: UITableView) -> QuotePriceTableViewCell{
        let reuseIdentifier = "QuotePriceTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = QuotePriceTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! QuotePriceTableViewCell
    }
    
}
