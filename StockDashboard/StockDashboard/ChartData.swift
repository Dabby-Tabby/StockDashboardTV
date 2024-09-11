import SwiftUI
import Charts
import SwiftYFinance

struct StockChartView: View {
    @StateObject private var viewModel: StockViewModel
    var color: Color
    var onTap: () -> Void
    @Binding var ticker: String

    init(ticker: Binding<String>, color: Color, onTap: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: StockViewModel(ticker: ticker.wrappedValue))
        self.color = color
        self.onTap = onTap
        _ticker = ticker
    }

    var body: some View {
        VStack {
            Button(action: {
                onTap() // Call the closure when clicked
            }) {
                VStack {
                    Text("\(viewModel.ticker) - 1 Week")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 820, height: 420)

                        if let currentPrice = viewModel.stockData.last?.price {
                            let minPrice = currentPrice * 0.90  // 10% below current price
                            let maxPrice = currentPrice * 1.10  // 10% above current price

                            Chart(viewModel.stockData) { data in
                                LineMark(
                                    x: .value("Date", data.date),
                                    y: .value("Price", data.price)
                                )
                                .foregroundStyle(color)
                                .symbol(Circle())
                            }
                            .frame(width: 800, height: 400)
                            .padding(10)
                            .chartYScale(domain: minPrice...maxPrice)  // Apply custom Y-axis scale
                        } else {
                            Text("Loading chart...")
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .onChange(of: ticker) { newTicker in
            viewModel.updateTicker(newTicker: newTicker)
        }
    }
}
