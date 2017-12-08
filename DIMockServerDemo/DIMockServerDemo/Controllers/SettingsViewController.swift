//
//  SettingsViewController.swift
//  DIMockServerDemo
//
//  Created by Piotr Adamczak on 16.11.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UIPickerViewDataSource, PickerCellDelegate {

    let currencies = Constants.currencies

    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PickerCell.cellIdentifier) as! PickerCell
        cell.delegate = self
        cell.picker.dataSource = self
        cell.detailTextLabel?.text = RestAPIManager.shared.currentCurrency
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let cell = tableView.cellForRow(at: indexPath) as? PickerCell {
            cell.showPicker()
        }
    }

    // MARK: UIPickerViewDatasource
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // MARK: PickerCellDelegate
    func pickerCellDidFinishPicking(selectedRow: Int) {
        RestAPIManager.shared.currentCurrency = currencies[selectedRow]
        self.tableView.reloadData()
    }

    func pickerCellGetTitleFor(row: Int) -> String? {
        return currencies[row]
    }

}
