//
//  Sets.swift
//  metrologiya
//
//  Created by Egor Pii on 10/17/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Foundation

let constOperatorsSet : Set = ["=", "/", "+", "-", "*", "if", "<", "<=", ">", ">=", "==", "!=", "for", "System", "++", "--", "new", "%", "+=", "-=", "*=", "/=", "%=", "->", "~", "&", "|", "^", ">>", "<<", "&=", "|=", "^=", "||", "&&", "!", "switch", "while", "do", "continue", "break", "return", "System.out.print", "System.in.read", "System.out.println", "System.in.readln", "Math.sqrt", "Math.sin", "Math.cos", "Math.tan", "Math.asin", "Math.acos", "main", "?"]

let constReservedSet : Set = ["int", "double", "String", "float", "byte", "short", "long", "class", "private", "static", "public", "throws", "else", "case", "default", "void", "char", "boolean"]

let typesSet : Set = ["int", "double", "String", "float", "byte", "short", "long", "void", "char", "boolean"]

let ariphmeticsSet : Set = ["+", "-", "=", "!", ">", "<", "&", "^", "|", "%", "/", "*", "?"]

let separatorsSet : Set = ["(", ")", "{", "}", ";", "[", "]"]

let lettersSet : Set = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "."]

let numbersSet : Set = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

var decremetSet : Set = ["if", "System.out.print", "System.in.read", "System.out.println", "System.in.readln", "Math.sqrt", "Math.sin", "Math.cos", "Math.tan", "Math.asin", "Math.acos", "main", "for", "switch", "while"]

let separatorIsOperator : Set = ["{", "(", ";"]

var operatorsSet = constOperatorsSet
var reservedSet = constReservedSet
