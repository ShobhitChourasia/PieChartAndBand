import XCTest
import PieChartAndBand

class Tests: XCTestCase {
    
    private var sut: PieBandViewModel?
    
    override func setUp() {
        super.setUp()
        sut = PieBandViewModel(dataManager: DataManager())
        sut?.getData()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    ///To check whether the response contains data
    func testIfDataHasStartAndEndValues() {
        guard let _ = sut?.dataModel.value?.startValue,
              let _ = sut?.dataModel.value?.endValue else {
            XCTAssert(false)
            return
        }
        XCTAssert(true)
    }
    
    ///To check whether the response contains valid data
    func testIfInputModelIsValid() {
        guard let startValue = sut?.dataModel.value?.startValue,
              let endValue = sut?.dataModel.value?.endValue else {
            XCTAssert(false)
            return
        }
        if startValue < endValue {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
