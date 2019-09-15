# Swift 实现敏感词过滤 - DFA算法

敏感词检测过滤是 App 中很重要的一个功能，敏感词数量动辄几千甚至上万，设计一个好的、高效的过滤算法是非常有必要的。那么有什么比较好的敏感词过滤算法吗？

Google 一下 !

## 一、 DFA算法简介
DFA 全称为：Deterministic Finite Automaton，即确定有穷自动机。剩下的理论没看懂就不 BB 了，想要了解的自己 Google 去。

## 二、Swift 实现 DFA 算法

#### 1、构建 DFA 模型

* 创建模型类
```
class Node {
    var chirldren = [String: Node]()
    var word = ""
 }
```

* 读取敏感词库到数组中
```
private func getSentiveWords() -> [String] {
    var rootArray = [String]()
    guard let filePath = Bundle.main.path(forResource: "SensitiveWords", ofType: nil) else {return [String]()}
    guard let filterString = try? String(contentsOfFile: filePath, encoding: .utf8) else {return [String]()}
    rootArray.append(contentsOf: filterString.components(separatedBy: "\r\n"))
    return rootArray
}
```

* 添加敏感词到 DFA 模型中

```
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
```

* 遍历敏感词数组，添加敏感词到 DFA 模型，完成模型构建
  
```
private func creatDFAModel() -> Node {
    let root = Node()
    let words = getSentiveWords()
    words.forEach { add($0, toRootNode: root) }
    return root
}
```

#### 2、敏感词检测与过滤

```
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
```

## 三、完整代码（含敏感词库）
[Swift 敏感词过滤](https://github.com/zhixingxi/SensitiveWord)
