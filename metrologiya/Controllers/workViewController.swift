//
//  workViewController.swift
//  metrologiya
//
//  Created by Egor Pii on 10/17/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Cocoa

fileprivate extension String {
    subscript(i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
}

class workViewController: NSViewController {

    //=== global values

    var codeArr : [String] = []
    var functionName = ""
    var globalOperatorsInfo = [elementInfo]()
    var globalOperandsInfo = [elementInfo]()

    //===

    @IBOutlet weak var inputCodeTextField: NSTextField!
    @IBOutlet weak var prograssPB: NSProgressIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()

        prograssPB.doubleValue = 0
        prograssPB.maxValue = 100.0
        inputCodeTextField.stringValue = ""
    }

    func dialogAlert(message : String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = "Incorrect data"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    @IBAction func loadButtonAction(_ sender: NSButton) {
        viewDidLoad()

        let dialog = NSOpenPanel();

        dialog.title                   = "Choose a .txt file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = false
        dialog.canCreateDirectories    = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes        = ["txt"]

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url
            let nameFile = result!.path

            do {
                let data = try String(contentsOfFile: nameFile, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                codeArr = myStrings
            } catch {
                print(error)
            }

        } else {
            dialogAlert(message: "Incorrect File!")
            return
        }

        for element in codeArr {
            var buffLine = element

            if !element.isEmpty {
                buffLine += "\n"
            }
            inputCodeTextField.stringValue += buffLine
        }

        prograssPB.increment(by: 50)
    }

    @IBAction func saveButtonAction(_ sender: NSButton) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose a .txt file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = false
        dialog.canCreateDirectories    = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes        = ["txt"]

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if let myResult = result {
                do {
                    try inputCodeTextField.stringValue.write(to: myResult, atomically: true, encoding: .utf8)
                }
                catch {
                    print("Failed writing to URL: \(myResult), Error: " + error.localizedDescription)
                }
            }
        } else {
            return
        }
    }

    @IBAction func checkButtonAction(_ sender: NSButton) {

        func getIndex (arr : [elementInfo], line : String) -> Int {
            for index in 0..<arr.count {
                if arr[index].name == line {
                    return index
                }
            }

            return -1
        }

        var message = "Right Code!"

        let checkerSet : Set = ["}", "{", ")", "(", ";", ":", "*", "/", "e", " ", "="]
        for element in codeArr {
            if element != "" {
                if !checkerSet.contains(String(element.last!)) {
                    message = "Invalid Code!"
                    print(element)
                    break
                    }
            }
        }

//        if getIndex(arr: separatorsInfo, line: "(") != -1 {
//            if separatorsInfo[getIndex(arr: separatorsInfo, line: "(")].count != separatorsInfo[getIndex(arr: separatorsInfo, line: ")")].count {
//                message = "Invalid Code!"
//            }
//        }
//
//        if getIndex(arr: separatorsInfo, line: "[") != -1 {
//            if separatorsInfo[getIndex(arr: separatorsInfo, line: "[")].count != separatorsInfo[getIndex(arr: separatorsInfo, line: "]")].count {
//                message = "Invalid Code!"
//            }
//        }
//
//        if getIndex(arr: separatorsInfo, line: "{") != -1 {
//            if separatorsInfo[getIndex(arr: separatorsInfo, line: "{")].count != separatorsInfo[getIndex(arr: separatorsInfo, line: "}")].count {
//                message = "Invalid Code!"
//            }
//        }


        dialogAlert(message: message)
    }

    @IBAction func resultButtonAction(_ sender: NSButton) {
        operatorsSet = constOperatorsSet
        reservedSet = constReservedSet

        globalOperandsInfo = []
        globalOperatorsInfo = []

        operatorsInfo = []
        operandsInfo = []
        separatorsInfo = []
        functions = [String : functionInfo]()

        func getWord (inputline : String, startIndex : Int, lastIndex : inout Int) -> String {
            var result = ""
            var flag = false

            for index in startIndex..<inputline.count {

                if !checkCharacter(inputCharacter: inputline[index]) && (inputline[index] != " "){
                    break
                }

                if (inputline[index] != " ") {
                    result.append(inputline[index])
                    flag = true
                }

                if inputline[index] == " " && flag {
                    break
                }

                lastIndex = index + 1
            }

            return result
        }

        func deleteSpaces(inputLine : String) -> String {
            var result = ""

            var flag = false
            for element in inputLine {
                if !(element == " " || element == "\t") {
                    flag = true
                }

                if flag {
                    result.append(element)
                }
            }

            return result
        }

        var flagComments = true
        var flagFunction = false

        for workElement in codeArr {

            let element = deleteSpaces(inputLine: workElement)

            var tmpIndex = 0

            var buffLine = getWord(inputline: element, startIndex: 0, lastIndex: &tmpIndex)

            if typesSet.contains(buffLine) {
                buffLine = ""
                buffLine = getWord(inputline: element, startIndex: tmpIndex+1, lastIndex: &tmpIndex)

                if !reservedSet.contains(buffLine) && !operatorsSet.contains(buffLine) && (tmpIndex+1 < element.count) && ((element[tmpIndex] == "(") || (element[tmpIndex] == " " && element[tmpIndex+1] == "(")) {
                    flagFunction = true

                    print("functionName = \(buffLine)")

                    functionName = buffLine
                    operatorsSet.insert(functionName)
                    openNum = 0
                    closeNum = 0
                }
            }

            workWithLine(inputLine: element, commentsBool: &flagComments, functionsBool: &flagFunction, functionName : functionName)

        }

        for element in separatorsInfo {
            if separatorIsOperator.contains(element.name) {
                operatorsInfo.append(element)
            }
        }

        var indexOpen = -1
        var indexCurly = -1
        var indexWhile = -1

        for index in 0..<operatorsInfo.count {
            if operatorsInfo[index].name == "{" {
                indexCurly = index
            }

            if operatorsInfo[index].name == "(" {
                indexOpen = index
            }

            if operatorsInfo[index].name == "while" {
                indexWhile = index
            }
        }

        if indexOpen < operatorsInfo.count && indexOpen > -1 && indexCurly > -1 && indexCurly < operatorsInfo.count && indexWhile < operatorsInfo.count {

            operatorsInfo[indexOpen].name = "( )"
            operatorsInfo[indexCurly].name = "{ }"

            if operatorsInfo[indexWhile].count == 0 {
                operatorsInfo.remove(at: indexWhile)
            }

            if operatorsInfo[indexOpen].count == 0 {
                operatorsInfo.remove(at: indexOpen)
            }
        }

        for element in operatorsInfo {
            if indexOpen > -1 {
                operatorsInfo[indexOpen].count -= (decremetSet.contains(element.name)) ? element.count : 0
            }

            if indexWhile > -1 {
                operatorsInfo[indexWhile].count -= (element.name == "do") ? element.count : 0
            }
        }

        globalOperatorsInfo = operatorsInfo
        globalOperandsInfo = operandsInfo


        prograssPB.increment(by: 50)

    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destinationController as! resultViewController

        destinationVC.tableOperators = globalOperatorsInfo
        destinationVC.tableOperands = globalOperandsInfo
    }

}
