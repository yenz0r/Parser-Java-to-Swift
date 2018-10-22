//
//  resultViewController.swift
//  metrologiya
//
//  Created by Egor Pii on 10/17/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Cocoa

class resultViewController: NSViewController {
    //values
    var tableOperators : [elementInfo] = []
    var tableOperands : [elementInfo] = []
    //end values

    @IBOutlet weak var staticLabel: NSTextField!
    @IBOutlet weak var operatorsInfoTextField: NSTextField!
    @IBOutlet weak var operandsInfoTextField: NSTextField!
    @IBOutlet weak var uniqOperatorsNumLabel: NSTextField!
    @IBOutlet weak var allOperatorsNumLabel: NSTextField!
    @IBOutlet weak var uniqOperandsNumLabel: NSTextField!
    @IBOutlet weak var allOperandsNumLabel: NSTextField!
    @IBOutlet weak var elementNameTextField: NSTextField!
    @IBOutlet weak var elementNumLabel: NSTextField!
    @IBOutlet weak var dictionaryLable: NSTextField!
    @IBOutlet weak var lengthLable: NSTextField!
    @IBOutlet weak var volumeLabel: NSTextField!

    func dialogAlert(message : String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = "Incorrect data"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    func inputTalbe(tableArr : [elementInfo], textField : NSTextField) {
        for element in tableArr {
            let buffLine = String(element.count) + "\t|\t" + element.name + "\n"
            textField.stringValue.append(buffLine)
        }
    }

    func getSum(tableArr : [elementInfo]) -> Int {
        var result = 0
        for element in tableArr {
            result += element.count
        }

        return result
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //values
            let uniqOperatorsNum = tableOperators.count
            let allOperatorsNum = getSum(tableArr: tableOperators)

            let uniqOperandsNum = tableOperands.count
            let allOperandsNum = getSum(tableArr: tableOperands)
        //end values

        inputTalbe(tableArr: tableOperators, textField: operatorsInfoTextField)
        inputTalbe(tableArr: tableOperands, textField: operandsInfoTextField)

        uniqOperatorsNumLabel.stringValue = String(uniqOperatorsNum)
        allOperatorsNumLabel.stringValue = String(allOperatorsNum)

        uniqOperandsNumLabel.stringValue = String(uniqOperandsNum)
        allOperandsNumLabel.stringValue = String(allOperandsNum)

        let dictionaryNum = uniqOperandsNum + uniqOperatorsNum
        let lengthNum = allOperatorsNum + allOperandsNum
        let volumeNum = lengthNum * Int(log2(Double(dictionaryNum)))

        dictionaryLable.stringValue = String(dictionaryNum)
        lengthLable.stringValue = String(lengthNum)
        volumeLabel.stringValue = String(volumeNum)

        staticLabel.stringValue = "0." + String(arc4random())
    }
    
    @IBAction func getInfoAction(_ sender: NSButton) {
        for element in tableOperators {
            if (element.name == elementNameTextField.stringValue) {
                elementNumLabel.stringValue = String(element.count)
                return
            }
        }

        for element in tableOperands {
            if (element.name == elementNameTextField.stringValue) {
                elementNumLabel.stringValue = String(element.count)
                return
            }
        }

        dialogAlert(message: "Empty element!")
    }
}
