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

			// Change the percent randomly between -5% to 15%
			let changePercent = Double.random(in: -0.05...15.00)
			stocks[i].price *= (1 + changePercent)

		}
	}
}

struct ContentView: View {
    var body: some View {
        VStack {
			List {
				ForEach(mockData) { stock in
					HStack {
						VStack {
							Text(stock.ticker)
							Text(stock.name)
								.font(.body.italic())
						}
						Spacer()
						Text(String(format: "$%.2f", stock.price))
					}
				}
			}
        }
    }
}

var mockData: [Stock] = [
	Stock(ticker: "TSLA",
		  name: "Tesla",
		  price: 440.00,
		  previousPrice: 338.00),
	Stock(ticker: "AAPL",
		  name: "Apple",
		  price: 255.46,
		  previousPrice: 250.22)
]

#Preview {
    ContentView()
}


