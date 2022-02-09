public struct Place {
    public var array: [[Int]]
    
    public var getTransposition: [[Int]] {
        get { privateTransposition() }
    }
    
    public var count: Int {
        get { array.count }
    }
    
    init(_ array: [[Int]]) {
        self.array = array
    }
    
    // MARK: - public function
    
    public mutating func transposition() {
        array = privateTransposition()
    }
    
    public mutating func by(_ num: Int) {
        var newArray = [[Int]]()
        
        for line in array {
            var lineArray = [Int]()
            
            for cell in line {
                if cell == num || cell == 0 {
                    lineArray.append(cell)
                } else {
                    lineArray.append(10)
                }
            }
               
            newArray.append(lineArray)
        }
        
        array = newArray
    }
    
    public mutating func repaceAllInLineBy(_ num: Int) {
        var newArray = array
        for i in 0...newArray.count-1 {
            if let j = newArray[i].firstIndex(where: { $0 == num }) {
                newArray[i] = Array(repeating: 10, count: 9)
                newArray[i][j] = num
            }
        }
        array = newArray
    }
    
    public mutating func count(_ num: Int) -> Int {
        var counter = 0
        for line in array {
            for cell in line {
                if cell == num {
                    counter += 1
                }
            }
        }
        return counter
    }
    
    public mutating func findPosition(num: Int) -> [Position] {
        var positions = [Position]()
        
        for row in 0...array.count - 1 {
            for column in 0...array[row].count - 1{
                let cell = array[row][column]
                
                if cell == num {
                    positions.append(Position(row: row, column: column))
                }
            }
        }
        
        return positions
    }
    
    // MARK: - privete function
    
    private func privateTransposition() -> [[Int]] {
        var newArray = [[Int]]()

        for i in 0...array[0].count - 1 {
            var newLine = [Int]()

            for j in 0...array.count - 1 {
                newLine.append(array[j][i])
            }

            newArray.append(newLine)
        }
        
        return newArray
    }
}

public struct Position {
    var row: Int
    var column: Int
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}
