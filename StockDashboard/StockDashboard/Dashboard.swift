import SwiftUI

struct Dashboard: View {
    @State private var showSheet = false
    @State private var selectedTicker = ""
    @State private var selectedIndex: Int?
    @State private var tickers: [String] = ["AAPL", "MSFT", "GOOGL", "AMZN"]

    var body: some View {
        VStack {
            HStack {
                VStack {
                    ForEach(0..<2, id: \.self) { index in
                        StockChartView(
                            ticker: $tickers[index],
                            color: index == 0 ? .red : .orange // Assign red to index 0 and blue to index 1
                        ) {
                            selectedIndex = index
                            selectedTicker = tickers[index]
                            showSheet = true
                        }
                    }
                }


                VStack {
                    ForEach(2..<4, id: \.self) { index in
                        StockChartView(
                            ticker: $tickers[index],
                            color: index == 2 ? .blue : .green // Assign blue to index 2 and green to index 3
                        ) {
                            selectedIndex = index
                            selectedTicker = tickers[index]
                            showSheet = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                VStack {
                    Text("Enter Ticker Symbol")
                        .font(.headline)
                        .padding()

                    TextField("Ticker Symbol", text: $selectedTicker)
                        .padding()

                    Button("Submit") {
                        // Ensure selectedIndex is valid before updating
                        if let index = selectedIndex, tickers.indices.contains(index) {
                            tickers[index] = selectedTicker
                        }
                        selectedTicker = ""
                        showSheet = false
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
}

#Preview {
    Dashboard()
}
