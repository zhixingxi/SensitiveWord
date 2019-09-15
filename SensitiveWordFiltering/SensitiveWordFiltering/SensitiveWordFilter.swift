//
//  SensitiveWordFilter.swift
//  SensitiveWordFiltering
//
//  Created by zhixing on 2019/9/14.
//  Copyright © 2019 zhixing. All rights reserved.
//  敏感词检测、过滤工具

import Foundation



class SensitiveWordFilter {
    
    deinit {
        print("释放 SensitiveWordFilter")
    }
    
    class Node {
        var chirldren = [String: Node]()
        var word = ""
    }
    
    typealias FilterResult = (isContain: Bool, filteredText: String)
 
    private lazy var root: Node = {
        return creatDFAModel()
    }()
    
    /// 敏感词过滤
    /// - Parameter text: 要检测的文本
    /// - Parameter replaceChar: 敏感词替换为某个字符，传入 "" 表示移除敏感词
    func filter(text: String, with replaceChar: String = "*") -> FilterResult {
        var filterdStr = text
        var isCotain = false
        for i in 0..<text.count {
            var p = root
            var j = i
            while j < text.count, p.chirldren[text[j]] != nil {
                p = p.chirldren[text[j]]!
                j += 1
            }
            if (p.word == text.subString(from: i, to: (j - 1))) && !p.word.isEmpty {
                var replaceStr = ""
                isCotain = true
                for _ in i..<j {
                    replaceStr.append(replaceChar)
                }
                filterdStr = filterdStr.replacingOccurrences(of: p.word, with: replaceStr)
            }
        }
        return (isCotain, filterdStr)
    }
    
    /// 初始化敏感词库，构建 DFA 算法模型
    private func creatDFAModel() -> Node {
        let root = Node()
        let words = getSentiveWords()
        words.forEach { add($0, toRootNode: root) }
        return root
    }
    
    /// 添加敏感词到模型中
    /// - Parameter word: 敏感词
    /// - Parameter root: DFA 模型
    private func add(_ word: String, toRootNode root: Node) {
        var node = root
        for letter in word {
            let letterStr = String(letter)
            if node.chirldren[letterStr] == nil {
                node.chirldren[letterStr] = Node()
            }
            node = node.chirldren[letterStr]!
        }
        node.word = word
    }
    
    private func getSentiveWords() -> [String] {
        var rootArray = [String]()
        guard let filePath = Bundle.main.path(forResource: "SensitiveWords", ofType: nil) else {return [String]()}
        guard let filterString = try? String(contentsOfFile: filePath, encoding: .utf8) else {return [String]()}
        rootArray.append(contentsOf: filterString.components(separatedBy: "\r\n"))
        return rootArray
    }
}


extension String {
    
    /// 按照下标截取字符串
    /// - Parameter from: 起始下标，从 0 开始，传入的不合法则默认为返回 " "
    /// - Parameter to: 结束下标，传入的不合法默认为返回 " "
    func subString(from: Int, to: Int) -> String {
        guard from >= 0,
            from < count,
            to >= 0,
            to < count,
            from <= to else {
                return ""
        }
        let s = index(startIndex, offsetBy: from)
        let e = index(startIndex, offsetBy: to)
        return String(self[s...e])
    }
    
    subscript (index: Int) -> String {
        return subString(from: index, to: index)
    }
}
