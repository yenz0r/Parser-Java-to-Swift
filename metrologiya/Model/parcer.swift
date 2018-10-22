//
//  main.swift
//  asdad
//
//  Created by Egor Pii on 10/16/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Foundation

fileprivate extension String {
    subscript(i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
}

var openNum = 0
var closeNum = 0

var tmpOperatorsInfo : infoArr = []
var tmpOperandsInfo : infoArr = []
var tmpSeparatorsInfo : infoArr = []

var operatorsInfo : infoArr = []
var operandsInfo : infoArr = []
var separatorsInfo : infoArr = []

var functions = [String : functionInfo]()

func checkCharacter (inputCharacter : Character) -> Bool {
    return lettersSet.contains(String(inputCharacter)) || numbersSet.contains(String(inputCharacter))
}

func checkInfo (inputWord : String, arrInfo : inout [elementInfo]) {
    for index in arrInfo.indices {
        if arrInfo[index].name == inputWord {
            arrInfo[index].count += 1
            return
        }
    }

    let tmpOperator = elementInfo(inputName: inputWord, inputCount: 1)
    arrInfo.append(tmpOperator)
}

func checkFunction(firstArr : infoArr, secondArr : inout infoArr) {
    for i in 0..<firstArr.count {
        var flagEqual = false
        for j in 0..<secondArr.count {
            if secondArr[j].name == firstArr[i].name {
                secondArr[j].count += firstArr[i].count
                flagEqual = true
            }
        }

        if !flagEqual {
            secondArr.append(firstArr[i])
        }

    }

}

func workWithLine (inputLine : String, commentsBool : inout Bool, functionsBool : inout Bool, functionName : String) {

    tmpSeparatorsInfo = []
    tmpOperatorsInfo = []
    tmpOperandsInfo = []

    var skipCount = 0

    var buffLine = ""

    for index in 0..<inputLine.count {

        if (index+1 < inputLine.count) {

            if (inputLine[index] == "*" && inputLine[index+1] == "/") {
                commentsBool = true
                break
            }

            if (inputLine[index] == "/" && inputLine[index+1] == "/") {
                break
            }

            if (inputLine[index] == "/" && inputLine[index+1] == "*") {
                commentsBool = false
            }

        }

        if !commentsBool {
            break
        }

        let element = inputLine[index]

        if (skipCount != 0) {
            skipCount -= 1
            continue
        }

        //обработка чисел
        if buffLine.isEmpty && numbersSet.contains(String(element)) {
            skipCount = 0
            buffLine.append(inputLine[index])



            var tmpIndex = index + 1
            if tmpIndex != inputLine.count {
                while (numbersSet.contains(String(inputLine[tmpIndex])) || inputLine[tmpIndex] == ".") {
                    skipCount += 1
                    buffLine.append(inputLine[tmpIndex])
                    tmpIndex += 1

                    if tmpIndex >= inputLine.count {
                        break
                    }
                }
            }


            checkInfo(inputWord: buffLine, arrInfo: &tmpOperandsInfo)

            buffLine = ""

        } else {
            //проверка на буквы и цифры
            if checkCharacter(inputCharacter: element) {
                buffLine.append(element)
                //print(buffLine)
            } else {
                if !buffLine.isEmpty {
                    //print(buffLine)
                    if operatorsSet.contains(buffLine) {
                        //print(buffLine)
                        checkInfo(inputWord: buffLine, arrInfo: &tmpOperatorsInfo)
                    } else {
                        //print(buffLine)
                        if !reservedSet.contains(buffLine) {
                            if buffLine.contains(".") {
                                var tmpIndex = 0
                                for element in buffLine {
                                    tmpIndex += 1
                                    if element == "." {
                                        break
                                    }
                                }

                                var nameFunction = ""
                                for index in tmpIndex..<buffLine.count {
                                    nameFunction.append(buffLine[index])
                                }

                                //обработка параметров ф-ции из общего кол-ва операторов/операндов
                                var flag = false
                                for (key, _) in functions {
                                    if (key == nameFunction) {
                                        flag = true
                                        break
                                    }
                                }

                                if flag {
                                    decremetSet.insert(nameFunction)

//                                    checkFunction(firstArr: functions[nameFunction]!.operatorsInfo, secondArr: &operatorsInfo)
//                                    checkFunction(firstArr: functions[nameFunction]!.operandsInfo, secondArr: &operandsInfo)
//                                    checkFunction(firstArr: functions[nameFunction]!.separatorsInfo, secondArr: &separatorsInfo)

                                    checkFunction(firstArr: functions[nameFunction]!.operatorsInfo, secondArr: &tmpOperatorsInfo)
                                    checkFunction(firstArr: functions[nameFunction]!.operandsInfo, secondArr: &tmpOperandsInfo)
                                    checkFunction(firstArr: functions[nameFunction]!.separatorsInfo, secondArr: &tmpSeparatorsInfo)

                                } else {
                                    checkInfo(inputWord: buffLine, arrInfo: &tmpOperatorsInfo)
                                }
                            } else {
                                checkInfo(inputWord: buffLine, arrInfo: &tmpOperandsInfo)
                            }
                        } else {
                            //обработка классов
                            if (buffLine == "class") {
                                buffLine = ""
                                var tmpIndex = index+1
                                while (!separatorsSet.contains(String(inputLine[tmpIndex])) && inputLine[tmpIndex] != " ") {
                                    buffLine.append(inputLine[tmpIndex])
                                    tmpIndex += 1

                                    if tmpIndex >= inputLine.count {
                                        break
                                    }
                                }

                                reservedSet.insert(buffLine)
                            }
                            //конец обработки классов
                        }
                    }
                }
                if (separatorsSet.contains(String(element))) {
                    buffLine = ""
                    if (element == "(") {
                        for tmpIndex in index+1..<inputLine.count {
                            if (inputLine[tmpIndex] != ")") {
                                buffLine.append(inputLine[tmpIndex])
                            } else {
                                break
                            }
                        }
                        let result = "(" + buffLine + ")"
                        if typesSet.contains(buffLine) {
                            checkInfo(inputWord: result, arrInfo: &operatorsInfo)
                        }
                    }
                    checkInfo(inputWord: String(element), arrInfo: &tmpSeparatorsInfo)
                }

                buffLine = ""

                // Обработка арифметики
                if ariphmeticsSet.contains(String(element)) && ariphmeticsSet.contains(String(inputLine[index + 1])) {
                    buffLine.append(inputLine[index])
                    buffLine.append(inputLine[index+1])
                    checkInfo(inputWord: buffLine, arrInfo: &tmpOperatorsInfo)

                    skipCount = 1
                } else {
                    if (ariphmeticsSet.contains(String(element))) {
                        checkInfo(inputWord: String(element), arrInfo: &tmpOperatorsInfo)
                    }
                }

                buffLine = ""

                //обработка String
                if (element == "\"") {
                    skipCount = 0
                    buffLine.append(element)
                    for tmpIndex in index+1..<inputLine.count {
                        buffLine.append(inputLine[tmpIndex])
                        skipCount += 1
                        if (inputLine[tmpIndex] == "\"") {
                            checkInfo(inputWord: buffLine, arrInfo: &tmpOperandsInfo)
                            break
                        }
                    }
                    buffLine = ""
                }

                //Обработка Char
                if (element == "'") {
                    skipCount = 0
                    buffLine.append(element)
                    for tmpIndex in index+1..<inputLine.count {
                        buffLine.append(inputLine[tmpIndex])
                        skipCount += 1
                        if (inputLine[tmpIndex] == "'") {
                            checkInfo(inputWord: buffLine, arrInfo: &tmpOperandsInfo)
                            break
                        }
                    }
                    buffLine = ""
                }
            }
        }
    }

    if functionsBool {

        print("===")
        print(functionsBool)

        var flag = false
        for (key, _) in functions {
            if key == functionName {
                flag = true
                break
            }
        }

        if flag {
            functions[functionName]!.operatorsInfo.append(contentsOf: tmpOperatorsInfo)
            functions[functionName]!.operandsInfo.append(contentsOf: tmpOperandsInfo)
            functions[functionName]!.separatorsInfo.append(contentsOf: tmpSeparatorsInfo)
//            tmpOperatorsInfo.append(contentsOf: functions[functionName]!.operatorsInfo)
//            tmpOperandsInfo.append(contentsOf: functions[functionName]!.operandsInfo)
//            tmpSeparatorsInfo.append(contentsOf: functions[functionName]!.separatorsInfo)
        } else {
            let tmpFunctionInfo = functionInfo(operatorsInfo: tmpOperatorsInfo, operandsInfo: tmpOperandsInfo, separatorsInfo: tmpSeparatorsInfo)
            functions[functionName] = tmpFunctionInfo
        }

        for element in tmpSeparatorsInfo {
            openNum += (element.name == "{") ? 1 : 0
            closeNum += (element.name == "}") ? 1 : 0
        }

        functionsBool = (openNum == closeNum && closeNum != 0) ? false : true
    } else {
        checkFunction(firstArr: tmpOperatorsInfo, secondArr: &operatorsInfo)
        checkFunction(firstArr: tmpOperandsInfo, secondArr: &operandsInfo)
        checkFunction(firstArr: tmpSeparatorsInfo, secondArr: &separatorsInfo)
    }
}

