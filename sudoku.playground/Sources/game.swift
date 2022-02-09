
public class Game {
    public var place = Place([[Int]]())
    
    public init(place: Place) {
        self.place = place
    }
    
    public convenience init(array: [[[[Int]]]]) {
        var newArray = [[Int]]()
        
        for lineGroup in array {
            for line in lineGroup {
                var lineArray = [Int]()
                
                for three in line {
                    for num in three {
                        lineArray.append(num)
                    }
                }
                
                newArray.append(lineArray)
            }
        }
        
        self.init(place: Place(newArray))
    }
    
    // MARK: - public functions
    
    public func show(header: String? = nil, footer: String? = nil) {
        print("\(header ?? "")\n", separator: "", terminator: "")
        printArray(place.array, numberRow: 3, numberColumn: 3)
        print("\(footer ?? "")\n", separator: "", terminator: "")
    }
    
    public func calculation() -> Bool {
        var numArray = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        var iteration = 0
        let maxIteration = 200
        
        while place.count(0) != 0 && iteration < maxIteration {
            for num in numArray {
                findeInGroupBy(num: num)
                
                for _ in 0...1 {
                    for lineIndex in 0...place.count - 1 {
                        checkLineBy(num, place: place, row: lineIndex, completion: { posArray in
                            if posArray.count == 1 {
                                place.array[lineIndex][posArray[0]] = num
                            } else if posArray.count == 2 && iteration == maxIteration - 1 {
                                let vc = vcPlace(place, row: lineIndex, positions: posArray, num: num)
                                if vc.check {
                                    place = vc.plc
                                    return
                                }
                            }
                        })
                    }
                    place.transposition()
                }
                
                if place.count(num) == 9 {
                    numArray = numArray.filter() { $0 != num }
                    iteration = 0
                }
            }
            
            if iteration % 10 == 0 && iteration != 0 {
//                print("iteration: \(iteration)")
            }
            
            iteration += 1
        }
        
        return iteration != maxIteration
    }
    
    // MARK: - private functions
    
    private func printArray(_ array: [[Int]], numberRow: Int, numberColumn: Int) {
        // FIXME: расчет полосок
        print("┌─────────┬─────────┬─────────┐")
        if array.count > 0 {
            let count = array.count
            for row in 0...count - 1 {
                for column in 0...count - 1 {
                    let columnLine = "│"
                    let cell = array[row][column]
                    
                    if column == 0 {
                        print(columnLine, separator: "", terminator: "")
                    }
                    
                    if cell == 10 {
                        print(" ◦ ", separator: "", terminator: "")
                        
                    } else if cell == 0 {
                        print(" * ", separator: "", terminator: "")
                    } else {
                        print(" \(cell) ", separator: "", terminator: "")
                    }
                    
                    if (column + 1) % numberColumn == 0 && column != count - 1 {
                        print(columnLine, separator: "", terminator: "")
                    }
                    
                    if column == count - 1 {
                        print(columnLine, separator: "", terminator: "")
                    }
                }
                
                print("")
                if (row + 1) % numberRow == 0 && row != count - 1 {
                    var counter = 0
                    print("├", separator: "", terminator: "")
                    for _ in 1...(count * 3 + Int(count/numberRow) * 2 - 4) {
                        
                        // FIXME: replace 8
                        if counter == 9 {
                            print("┼", separator: "", terminator: "")
                            counter = 0
                        } else {
                            print("─", separator: "", terminator: "")
                            counter += 1
                        }
                        
                    }
                    print("┤")
                }
            }
        }
        print("└─────────┴─────────┴─────────┘")
    }
    
    private func findeInGroupBy(num: Int) {
        var newArray = place
        newArray.by(num)
        
        // replace in line
        newArray.repaceAllInLineBy(num)
        
        // replace in column
        newArray.transposition()
        newArray.repaceAllInLineBy(num)
        newArray.transposition()
        
        for groupRow in 0...2 {
            for groupColumn in 0...2 {
                let pos = Position(row: groupRow, column: groupColumn)
                var arrayFromGroup = arrayGroup(position: pos, fromArray: newArray.array)
                
                if arrayFromGroup.count(num) == 0 {
                    let positionArray = arrayFromGroup.findPosition(num: 0)
                    
                    if positionArray.count == 1 {
                        var findPos: Position = positionArray[0]
                        findPos.row = groupRow * 3 + findPos.row
                        findPos.column = groupColumn * 3 + findPos.column
                        place.array[findPos.row][findPos.column] = num
                    }
                }
            }
        }
    }
    
    private func checkLineBy(_ num: Int, place: Place, row: Int, completion: ([Int])->()) {
        var trArray = place
        trArray.transposition()
        
        
        let lineArray = place.array[row]
        if lineArray.firstIndex(where: { $0 == num }) == nil {
            var posArray = [Int]()
            var cellIndex = 0
            for cell in lineArray {
                if cell == 0 {
                    let horizonArray = trArray.array[cellIndex]
                    if horizonArray.firstIndex(where: { $0 == num }) == nil {
                        posArray.append(cellIndex)
                    }
                }
                cellIndex += 1
            }
            completion(posArray)
        }
    }
    
    func vcPlace(_ place: Place, row: Int, positions: [Int], num: Int) -> (check: Bool, plc: Place) {
        var plc1 = place
        var plc2 = place

        plc1.array[row][positions[0]] = num
        plc2.array[row][positions[1]] = num

        let game1 = Game(place: plc1)
        let game2 = Game(place: plc2)

        if game1.calculation() {
            return (true, plc1)
        }

        if game2.calculation() {
            return (true, plc2)
        }
        
        return (false, Place([[Int]]()))
    }
    
    // MARK: - array functions
    
    private func arrayGroup(position: Position, fromArray: [[Int]]) -> Place {
        var newArray = [[Int]]()
        let rowFrom = position.row * 3
        let columnFrom = position.column * 3
        
        for rowGroup in (rowFrom)...(rowFrom + 2) {
            var lineArray = [Int]()
            for columnGroup in (columnFrom)...(columnFrom + 2) {
                lineArray.append(fromArray[rowGroup][columnGroup])
            }
            newArray.append(lineArray)
        }
        
        return Place(newArray)
    }
}
