//
//  ContentView.swift
//  StockTrackDummy
//
//  Created by Bidisha Biswas on 9/27/25.
//

import SwiftUI
internal import Combine

struct Stock: Identifiable {
	let id = UUID()
	let ticker: String
	let name: String
	var price: Double
	var previousPrice: Double

	var change: Double { price - previousPrice }
	var percentChanged: Double { (change / previousPrice) * 100 }
}

class StockViewModel: ObservableObject {
	@Published var stocks: [Stock] = []
	private var timer: Timer?

	init() {
		loadMockData()
	}

	deinit {
		timer?.invalidate()
	}

	func loadMockData() {
		stocks = mockData
	}

	func startTimer() {
		timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { [weak self] _ in
			self?.modifyStockPrice()
		})
	}

	func modifyStockPrice() {
		for i in 0..<stocks.count {
			stocks[i].previousPrice = stocks[i].price

			let change = Double.random(in: -10.0...10.0)
			stocks[i].price = max(0.01, stocks[i].price + change)

		}
	}
}

struct ContentView: View {
	@StateObject private var viewModel = StockViewModel()

	var body: some View {
		NavigationStack {
			List {
				ForEach(viewModel.stocks) { stock in
					HStack {
						VStack(alignment: .leading) {
							Text(stock.ticker)
							Text(stock.name)
								.font(.body.italic())
						}
						Spacer()
						HStack {
							Text(String(format: "$%.2f", stock.price))
								.foregroundStyle(stock.percentChanged >= 0 ? Color.green : Color.red)
								.animation(.easeInOut(duration: 0.3), value: stock.price)
							Image(systemName: stock.percentChanged >= 0 ? "arrow.up" : "arrow.down")
								.resizable().frame(width: 10, height: 10)
								.scaleEffect(stock.percentChanged >= 0 ? 1.2 : 1.1)
								.foregroundStyle(stock.percentChanged >= 0 ? Color.green : Color.red)
								.animation(.spring(), value: stock.percentChanged)
						}
					}
				}

			}
			.task {
				viewModel.startTimer()
			}
			.navigationTitle("Stocks")
		}
	}
}

var mockData: [Stock] = [
	Stock(ticker: "TSLA", name: "Tesla", price: 440.00, previousPrice: 338.00),
	Stock(ticker: "AAPL", name: "Apple", price: 255.46, previousPrice: 250.22),
	Stock(ticker: "LULU", name: "Lululemon", price: 176.30, previousPrice: 173.22)
]

#Preview {
    ContentView()
}


