//
//  ExpensesView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 02/11/2022.
//

import SwiftUI
import Charts

struct ExpensesView: View {
    
    enum VisibleState {
        case displayed, hidden
    }
    
    @EnvironmentObject var viewModel : ExpensesScreenViewModel
    @State var hideExpensesView : Bool = false
    @State var visibleState : VisibleState = .displayed
    @State var currentScrollValue : CGFloat = .zero
        
    var body: some View {
        let width : CGFloat = 400
        let height : CGFloat =  400
        
        VStack {
            ScrollView(.horizontal){
                ScrollViewReader{ reader in
                    Chart{
                        ForEach(viewModel.expensesGraphData, id: \.id) { data in
                            BarMark(x: .value("Date", data.transaction.date.toDayShortFormat()),
                                    y: .value("Amount", data.transaction.amount)
                            )
                            .foregroundStyle(by:.value("cardNumber", data.secretCardNumber))
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .chartPlotStyle { plotArea in
                        plotArea
                            .background(.white.opacity(0.2))
                    }
                    .chartXAxisLabel("Payment Date", alignment: .center)
                    .chartYAxisLabel("Amount", alignment: .center)
                    .chartOverlay { proxy  in
                        GeometryReader { geo in
                            Rectangle().fill(.clear).contentShape(Rectangle())
                                .onTapGesture { location in
                                    findSelectedTask(
                                        at: location,
                                        proxy: proxy,
                                        geometry: geo)
                                }
                        }
                    }
                    .id(1)
                    .onAppear{
                        reader.scrollTo(1,anchor: .leading)
                    }
                }
                .frame(width: width, height: height)
            }
        }
        .frame(height: height)
    }
    
    private func findSelectedTask(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        guard let date: String = proxy.value(atX: xPosition) else {
            return
        }
        
        viewModel.findSelectedPaymentsForDate(date)
    }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView()
            .environmentObject(ExpensesScreenViewModel())
    }
}
