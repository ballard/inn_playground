import UIKit

var str = "Hello, playground"

enum Weights: Int {
    case ten = 10
    case eleven
    case twelve
    
    func value() -> [Int] {
        switch self {
        case .ten:
            return [2,4,10,3,5,9,4,6,8,0]
        case .eleven:
            return [7,2,4,10,3,5,9,4,6,8,0]
        case .twelve:
            return [3,7,2,4,10,3,5,9,4,6,8,0]
        }
    }
}

func validateINN(_ inn: String) -> Bool {
    guard inn.count == 10 || inn.count == 12 else {
        return false
    }
    if inn == "0000000000" || inn == "0000000000000" {
        return false
    }
    guard let weights = Weights.init(rawValue: inn.count)?.value() else {
        return false
    }
    let controlNumberOne = calculateControlNumber(inn, weights: weights)
    let isNumberOneValid = controlNumberOne == Int(String(inn.last ?? "0")) ?? 0
    if inn.count == 10 {
        return isNumberOneValid
    }
    guard let secondWeights = Weights.init(rawValue: inn.count - 1)?.value() else {
        return false
    }
    let controlNumberTwo = calculateControlNumber(inn, weights: secondWeights)
    let isNumberTwoValid = controlNumberTwo == Int(String(inn.dropLast().last ?? "0")) ?? 0
    return isNumberOneValid && isNumberTwoValid
}

func calculateControlNumber(_ input: String, weights: [Int]) -> Int {
    let sum = zip(input.compactMap { Int(String($0)) }, weights).reduce(0) { $0 + ($1.0 * $1.1) }
    let result = sum % 11
    if result <= 9 {
        return result
    }
    return result % 10
}

let succeess = validateINN("7647161657")
