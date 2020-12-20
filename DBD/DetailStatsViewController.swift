import UIKit
import Charts
import Firebase

class DetailStatsViewController: UIViewController {
    
    // MARK: Properties
    
    var statName = ""
    var statValue = ""
    
    var steamID = ""
    var statKey = ""
    
    /* debug */
    //let StatsData: [Double] = [120, 150, 0,0,0,0, 140]
    var weeklyStatsData: [Double] = Array(repeating: 0, count: 7)
    
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailValue: UILabel!
    @IBOutlet weak var barChart: BarChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailName.text = statName
        detailValue.text = statValue
        
        getWeeklyStats(steamID: steamID, statNameKey: statKey, completion: {
            self.setBarChart(dataList: self.weeklyStatsData)
            print("show Graph")
        })
        /* debug */
        // setBarChart(dataList: StatsData)
    }
    
    
    // MARK: Methods
    
    private func getWeeklyStats(steamID: String, statNameKey: String, completion: @escaping() -> ()) {
        // debug
        let steamID = "76561198863602426"
        let statNameKey = "DBD_BloodwebPoints"
        
        /* setDateFormat */
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        let calendar = Calendar.current
        
        // 今日から遡って7日分のデータを取得し配列に格納する
        // weeklyStatsData["7日前", "6... , "今日"]  (旧)<-->(新)
        let howManyDays = 7
        var count = 0
        for i in (-howManyDays + 1)...0 {
            /* 日付の取得 */
            let addingDate = calendar.date(byAdding: .day, value: i, to: date)
            let formatedDate = format.string(from: addingDate!)
            print("i: \(i) date:\(formatedDate)")
            
            /* firestoreの読み込み */
            /* weeklyStatsData配列に格納 */
            setStatFromFirestore(steamID: steamID, date: formatedDate, statKey: statNameKey, index: i + (howManyDays-1), completion: {
                
                count = count + 1
                print("count(\(count))Firestore Done.\n")
                if count == 7 {
                    completion()
                }
            })
        }
    }
    
    private func setStatFromFirestore(steamID: String, date: String, statKey: String, index: Int, completion: @escaping () -> ()) {
        /*  debug
         *  let steamID = "76561198863602426"
         *  let date = 20201219
         *  let statNameKey = "DBD_BloodwebPoints"
         *  let index = 0 */
        // index: 配列のindexの番号の箇所にfirestoreから取得したデータかデータがなければ0を格納する
        // 配列: weeklyStatsData["7日前", "6... , "今日"]  (旧)<-->(新)
        
        let db = Firestore.firestore()
        let docRef = db.collection("\(steamID)").document("\(date)")

        docRef.getDocument() { (document, error) in
            defer {
                debugPrint(self.weeklyStatsData)
                completion()
            }
            self.weeklyStatsData[index] = 0
            
            if let document = document, document.exists {

                guard let result: [String : Any] = document.data()?["stats"] as? [String : Any] else {
                    print("index: \(index), result error")
                    return
                }
                guard let statValue = result["\(statKey)"] as? Double else {
                    print("index: \(index), statValue error")
                    return
                }
                self.weeklyStatsData[index] = round(statValue)
                print("index: \(index), statValue: \(statValue)")

            } else {
                print("index: \(index), Document does not exist")
            }
        }
    }
    
    private func setBarChart(dataList: [Double]) {
        let entries = dataList.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        
        let dataSet = BarChartDataSet(entries: entries)
        let data = BarChartData(dataSet: dataSet)
        barChart.data = data
        
        /* x軸 */
        //barChart.xAxis.enabled = false
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.drawAxisLineEnabled = false
         //X軸のラベルを設定
        let xaxis = XAxis()
        xaxis.valueFormatter = BarChartFormatter()
        barChart.xAxis.valueFormatter = xaxis.valueFormatter
        
        /* y軸 */
        barChart.rightAxis.enabled = false
        barChart.leftAxis.axisMinimum = 0.0
        barChart.leftAxis.drawZeroLineEnabled = true
        barChart.leftAxis.drawAxisLineEnabled = false
        barChart.legend.enabled = false
        
        /* 他 */
        barChart.animate(yAxisDuration: 0.75)
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        barChart.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        dataSet.colors = [UIColor(red: 50/255, green: 100/255, blue: 255/255, alpha: 0.85)]
        data.barWidth = 0.63
    }
}

public class BarChartFormatter: NSObject, IAxisValueFormatter {
    // x軸のラベル
    var weeklyLabel: [String]! = ["6 days ago", "5", "4", "3", "2", "1", "Today"]

    // デリゲート。TableViewのcellForRowAtで、indexで渡されたセルをレンダリングするのに似てる。
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        // 0 -> Jan, 1 -> Feb...
        return weeklyLabel[Int(value)]
    }
}
