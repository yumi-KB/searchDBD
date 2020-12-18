import UIKit
import Charts

class DetailStatsViewController: UIViewController {
    var name = ""
    var value = ""
    
    @IBOutlet weak var detailname: UILabel!
    @IBOutlet weak var detailvalue: UILabel!
    @IBOutlet weak var barChart: BarChartView!
    
    let unitsSold = [10.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailname.text = name
        detailvalue.text = value
        
        let weeklyStatsData: [Int] = [120, 150, 0,0,0,0, 140]
       // let xAxisData: [Int] = [12-09, 12-10, 12-11, 12-12,12-13,12-14,12-15]
        let entries = weeklyStatsData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
//        for i in weeklyStatsData {
//          let entries = BarChartDataEntry(x :Double(xAxisData[i]), y: Double(weeklyStatsData[i]))
//        }
        let dataSet = BarChartDataSet(entries: entries)
        let data = BarChartData(dataSet: dataSet)
        barChart.data = data

        barChart.animate(yAxisDuration: 0.75)
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        barChart.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        dataSet.colors = [UIColor(red: 50/255, green: 100/255, blue: 255/255, alpha: 0.85)]
        data.barWidth = 0.63
        
        /* x軸 */
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.drawAxisLineEnabled = false
        
        /* y軸 */
        barChart.rightAxis.enabled = false
        barChart.leftAxis.axisMinimum = 0.0
        barChart.leftAxis.drawZeroLineEnabled = true
        // ラベルの数を設定
            // barChart.leftAxis.labelCount = 5
        barChart.leftAxis.drawAxisLineEnabled = false

    }
}
