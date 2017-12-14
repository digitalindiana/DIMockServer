//
//  CoinsViewController.swift
//  DIMockServerDemo
//
//  Created by Piotr Adamczak on 16.11.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import UIKit

class CoinsViewController: UITableViewController {

    var coins: [Coin] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to fetch current prices")
        self.refreshControl?.addTarget(self, action: #selector(CoinsViewController.fetchCoins), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchCoins()
    }

    // MARK: Coin getter
    func coinAt(_ indexPath: IndexPath) -> Coin? {
        if indexPath.row < coins.count {
            return self.coins[indexPath.row]
        } else {
            return nil
        }
    }

    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.cellIdentifier) as! CoinCell

        guard let coin = self.coinAt(indexPath) else {
            return cell
        }

        cell.coinName.text = coin.name
        cell.priceLabel.text = coin.formattedPrice()
        cell.priceDifferenceLabel.text = coin.formattedDifference()
        return cell
    }
}

extension CoinsViewController {

    func fetchCoins() {
        RestAPIManager.shared.fetchTopCoins { (json, currency, error) in

            DispatchQueue.main.async{
                self.refreshControl?.endRefreshing()
            }

            if let jsonArray = json?.array {
                //Parse fresh coin info
                var coins = jsonArray.map { return Coin(JSON: $0, currency: currency) }

                //Update last price
                coins = coins.map({ (freshCoin) -> Coin in
                    let savedCoin = self.coins.filter { $0.uid == freshCoin.uid }.first
                    freshCoin.lastPriceUsd = savedCoin?.priceUsd
                    return freshCoin
                })

                //Sort
                self.coins = coins.sorted { $0.rank < $1.rank }

                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }

            } else if let error = error {
                self.showRequestErrorAlert(error)
            }
        }
    }

    func showRequestErrorAlert(_ error: Error) {
        let alertController = UIAlertController(title: "Ouch :(", message: "Something went wrong..", preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)

        present(alertController, animated: true, completion: nil)
    }
}
