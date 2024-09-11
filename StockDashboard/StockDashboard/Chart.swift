import SwiftUI
import SwiftYFinance

struct StockData: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}

class StockViewModel: ObservableObject {
    @Published var stockData: [StockData] = []
    @Published var ticker: String

    init(ticker: String) {
        self.ticker = ticker
        fetchStockData()
    }
    
    func fetchStockData() {
        let calendar = Calendar.current
        let today = Date()
        let oneWeekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: today)!

        SwiftYFinance.chartDataBy(
            identifier: ticker,
            start: oneWeekAgo,  // Use oneWeekAgo instead of oneYearAgo
            end: today,
            interval: .oneday
        ) { [weak self] data, error in
            if let data = data {
                DispatchQueue.main.async {
                    self?.stockData = self?.parseStockData(data) ?? []
                }
            } else if let error = error {
                print("Error fetching stock data: \(error)")
            }
        }
    }


    func updateTicker(newTicker: String) {
        self.ticker = newTicker
        fetchStockData()
    }

    private func parseStockData(_ data: [StockChartData?]) -> [StockData] {
        var stockArray = [StockData]()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        for item in data {
            if let date = item?.date, let close = item?.close {
                let stock = StockData(date: date, price: Double(close))
                stockArray.append(stock)
            }
        }

        return stockArray.sorted { $0.date < $1.date }
    }
}
