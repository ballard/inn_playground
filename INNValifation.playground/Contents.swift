import UIKit

var str = "Hello, playground"

struct INNValidator {
    
    private enum Weights: Int {
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
    
    func validateNumber(_ number: String) -> Bool {
        guard number.count == 10 || number.count == 12 else {
            return false
        }
        if number == "0000000000" || number == "0000000000000" {
            return false
        }
        let isNumberOneValid = checkValidity(number, for: true)
        if number.count == 10 {
            return isNumberOneValid
        }
        let isNumberTwoValid = checkValidity(number, for: false)
        return isNumberOneValid && isNumberTwoValid
    }
    
    private func checkValidity(_ input: String, for first: Bool) -> Bool {
        let count = first ? input.count : input.count - 1
        guard let weights = Weights.init(rawValue: count)?.value() else {
            return false
        }
        let controlNumberOne = calculateControlNumber(input, weights: weights)
        let validationNumber = Int(String((first ? input.last : input.dropLast().last) ?? "0")) ?? 0
        return controlNumberOne == validationNumber
    }
    
    private func calculateControlNumber(_ input: String, weights: [Int]) -> Int {
        let sum = zip(input.compactMap { Int(String($0)) }, weights).reduce(0) { $0 + ($1.0 * $1.1) }
        let result = sum % 11
        if result <= 9 {
            return result
        }
        return result % 10
    }
}

let succeess = INNValidator().validateNumber("7647161657")

import XCTest
class INNValidatorTests: XCTestCase {
    
    
    var validator: INNValidator!
    
    let validNumbers = "7958511128,2351772610,6326235802,3680771557,7287333900,7647161657,8803701921,1762637414,0733802069,9069418210,0527763382,7488832804,8468796701,248475559389,775659694233,769604247325,456635172535,775884901473,189568266358,275223817941,028907186210,246674442279,346826504782,687411799012,866973071173,657144319303"
    
    let invalidNumbers = "7958511129,2351772610,6326235802,3680771557,7287333900,7647161657,8803701921,1762637414,0733802069,9069418210,0527763382,7488832804,8468796701,248475559389,775659694233,769604247325,456635172535,775884901473,189568266358,275223817941,028907186210,246674442279,346826504782,687411799012,866973071173,657144319303"
    
    override func setUp() {
        super.setUp()
        validator = INNValidator()
    }
    
    func testValidNumbers() {
        
        var result = true
        
        for number in validNumbers.components(separatedBy: ",") {
            let isValid = validator.validateNumber(number)
            result = isValid
            if !isValid {
                break
            }
            
        }
        
        XCTAssertEqual(result, true)
    }
    
    func testInvalidNumbers() {
        
        var result = true
        
        for number in invalidNumbers.components(separatedBy: ",") {
            let isValid = validator.validateNumber(number)
            result = isValid
            if !isValid {
                break
            }
            
        }
        
        XCTAssertEqual(result, true)
    }
    
    
}

let test = INNValidatorTests()
test.setUp()
test.testValidNumbers()
test.testInvalidNumbers()
