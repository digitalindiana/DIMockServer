//
//  CoinCell.swift
//  DIMockServerDemo
//
//  Created by Piotr Adamczak on 08.12.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import UIKit

protocol PickerCellDelegate {
    func pickerCellDidFinishPicking(selectedRow: Int)
    func pickerCellGetTitleFor(row: Int) -> String?
}

class PickerCell: UITableViewCell, UIPickerViewDelegate {

    static let cellIdentifier = "PickerCellIdentifier"

    let toolBar = UIToolbar()
    let picker = UIPickerView()
    let textField = UITextField(frame: CGRect.zero)

    var selectedRow: Int = 0
    var delegate: PickerCellDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        picker.showsSelectionIndicator = true
        picker.delegate = self

        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain,
                                         target: self, action: #selector(PickerCell.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
                                          target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain,
                                         target: self, action: #selector(PickerCell.cancelPicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.contentView.addSubview(textField)
        textField.inputView = picker
        textField.inputAccessoryView = toolBar
    }

    @IBAction func showPicker() {
        textField.becomeFirstResponder()
    }

    func cancelPicker() {
        textField.resignFirstResponder()
    }

    func donePicker() {
        textField.resignFirstResponder()
        self.delegate?.pickerCellDidFinishPicking(selectedRow: self.selectedRow)
    }

    // MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.delegate?.pickerCellGetTitleFor(row: row)
    }
}
