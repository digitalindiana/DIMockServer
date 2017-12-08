//
//  CoinCell.swift
//  DIMockServerDemo
//
//  Created by Piotr Adamczak on 08.12.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import UIKit

class CoinCell: UITableViewCell {

    static let cellIdentifier = "CoinCellIdentifier"

    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var priceDifferenceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

}
