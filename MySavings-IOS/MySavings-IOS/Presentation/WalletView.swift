//
//  WalletView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/10/2022.
//

import SwiftUI
import Combine
import Charts

struct WalletView: View {
    
    @StateObject var walletViewModel : WalletViewModel = .init()
    @State var showBigCard : Bool = false
    @State var hideExpensesView : Bool = false
    @State var showPaymentsForDate : Bool = false
    @State var center : CGPoint = .zero
    @State var currentScrollValue : CGFloat = .zero
    @State var transactionData : [TransactionData] = .init()
    @Namespace var scrollSpace
    
    @State var selectedTab : String = ""
    
    
    var body: some View {
        ScrollView{
            
            let paddingTop : CGFloat =  hideExpensesView ? 150 : 20
            
            MonthAllowedBudgetView()
            
            if showBigCard{
                SelectedCardView(card: walletViewModel.selectedCard)
            }else{
                VStack{
                    ExpensesView()
                        .padding(.bottom, paddingTop)
                    
                    CardListView()
                        .padding(.top, paddingTop)
                    
                }
                .animation(.linear, value: walletViewModel.selectedCardTransactions)
            }
            
        }
        .animation(.linear, value: showBigCard)
        .preferredColorScheme(.dark)
        .onReceive(walletViewModel.$selectedCard) { card in
            showBigCard = card.isSelected
        }
        .onReceive(walletViewModel.$cardUsedForPayment) { cards in
            guard !cards.isEmpty else {return}
            showPaymentsForDate = !cards.isEmpty
        }
        .sheet(isPresented: $showPaymentsForDate) {
            let cards = walletViewModel.cardUsedForPayment
            TabView {
                ForEach(cards) { card in
                    VStack{
                        CreditCardView(card: card)
                            .scaleEffect( 1.5)
                        VStack {
                            ForEach(card.cardData.transaction, id: \.self) { transaction in
                                HStack{
                                    Text(transaction.reason)
                                        .font(.body)
                                    Spacer()
                                    Text(transaction.amount.formatted() + "₪")
                                        .font(.body.bold())
                                }
                                .padding(.horizontal)
                                .frame(height: 50)
                                .background(Color.white.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(.top, 50)
                    }
                    .transition(.scale)
                    .padding(.top, 80 )
                    .frame(width: 400)
                    .tabItem {
                        Text(card.cardNumber)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func MonthAllowedBudgetView() -> some View{
        let foregroundColor : Color = walletViewModel.budgetLeft.isPositive() ? Color.green : Color.red
        ZStack{
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.white.opacity(0.3))
            
            Text("\(walletViewModel.budgetLeft.formatted()) ₪")
                .font(.title.bold())
                .foregroundColor(foregroundColor)
        }
        .padding(30)
        
    }
    
    
    @ViewBuilder
    func ExpensesView() -> some View{
        let width = walletViewModel.expensesGraphData.count < 8 ? 300 : CGFloat(walletViewModel.expensesGraphData.count) * 20
        let height : CGFloat = hideExpensesView ? 1 : 400
        VStack {
            
            Label("Expenses", systemImage: "lines.measurement.horizontal")
                .frame(width: 300, alignment: .leading)
                .font(.body.bold())
                        
            ScrollView(.horizontal){
                ScrollViewReader{ reader in
                    Chart{
                        ForEach(walletViewModel.expensesGraphData, id: \.id) { data in
                            BarMark(x: .value("Date", data.transaction.date.toDayShortFormat()),
                                    y: .value("Amount", data.transaction.amount)
                            )
                            .foregroundStyle(by:.value("cardNumber", data.cardNumber))
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
            .background(GeometryReader { geo in
                let offset = -geo.frame(in: .named(scrollSpace)).minY
                Color.clear
                    .preference(key: ScrollViewOffsetPreferenceKey.self,
                                value: offset)
            })
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                withAnimation {
                    hideExpensesView = value > 1
                }
            }
        }
        .onAppear{
            walletViewModel.getTransactions()
            
        }
        .frame(height: height)
        
    }
    
    @ViewBuilder
    func CardListView() -> some View {
        VStack{
            
            Label("Cards", systemImage: "creditcard")
                .frame(width: 300, alignment: .leading)
                .font(.title.bold())
            
            
            LazyVStack{
                ForEach(walletViewModel.cardModel, id: \.id) { card in
                    CreditCardView(card: card)
                    .onTapGesture {
                        walletViewModel.selectCard(card)
                    }
                    .animation(.linear, value: card.isSelected)
                }
            }
        }
        .transition(.move(edge: .bottom))
    }
    
    @ViewBuilder
    func SelectedCardView(card : CardModel) -> some View{
        VStack{
            CreditCardView(card: card)
                .scaleEffect(showBigCard ? 1.5 : 0)
                .id(2)
                .onTapGesture {
                    walletViewModel.unselectCar()
                }
            
            VStack {
                ForEach(walletViewModel.selectedCardTransactions, id: \.self) { transaction in
                    HStack{
                        Text(transaction.reason)
                            .font(.body)
                        Spacer()
                        Text(transaction.amount.formatted() + "₪")
                            .font(.body.bold())
                    }
                    .padding(.horizontal)
                    .frame(height: 50)
                    .background(Color.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.top, 50)
        }
        .transition(.scale)
        .padding(.top, 80 )
        .frame(width: 400)
    }
    
    private func findSelectedTask(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        guard let date: String = proxy.value(atX: xPosition) else {
            return
        }
                
        walletViewModel.findSelectedPaymentsForDate(date)
    }
}

class WalletViewModel : ObservableObject{
    
    
    @Published var budgetLeft : Double = 0.0
    @Published var cardUser : CardUser = .init()
    @Published var expensesGraphData : [ExpenseGraphModel] = .init()
    @Published var cardModel : [CardModel] = .init()
    @Published var cardUsedForPayment : [CardModel] = .init()
    @Published var selectedCardTransactions : [TransactionData] = .init()
    @Published var selectedCard : CardModel = .init(cardData: CreditCardData(name: ""))
    var subsriptions = Set<AnyCancellable>()
    var selectedCardEvent  = PassthroughSubject<CardModel, Never>()
    
    init(){
        cardUser.cards.forEach { card in
            cardModel.append(CardModel(cardData:card))
        }
        observe()
    }
    
    func observe(){
        let publisher =  selectedCardEvent
            .receive(on: DispatchQueue.main)
            .zip($cardModel)
            .share()
        
        publisher.map{selectedCard, _ in
            let isEmpty = selectedCard.name.isEmpty
            var copy = selectedCard
            copy.isSelected = !isEmpty
            return copy
        }
        .assign(to: &$selectedCard)
        
        publisher.map(\.0)
            .flatMap({ cardModel -> AnyPublisher<TransactionData,Never> in
                cardModel.cardData.transaction
                    .publisher
                    .eraseToAnyPublisher()
            })
            .zip(Timer
                .publish(every: 0.3, on: RunLoop.main, in: .default).autoconnect())
            .sink { transactionData in
                if !self.selectedCard.name.isEmpty{
                    self.selectedCardTransactions.append(transactionData.0)
                }else{
                    self.selectedCardTransactions = []
                }
            }
            .store(in: &subsriptions)
        
        publisher
            .receive(on: DispatchQueue.main)
            .flatMap{ selectedCard, cardModels -> AnyPublisher<[CardModel], Never> in
                return cardModels.filter{ $0 != selectedCard }
                    .publisher
                    .map { model in
                        var copy = model
                        copy.isSelected = false
                        return copy
                    }
                    .collect()
                    .eraseToAnyPublisher()
            }
            .sink { cards in
                var received = cards
                if !self.selectedCard.name.isEmpty{
                    received.append(self.selectedCard)
                }
                self.cardModel = received.sorted(by: {$0.name > $1.name})
            }
            .store(in: &subsriptions)
        
        
        cardUser.cards
            .publisher
            .flatMap{ card in
                card.transaction
                    .publisher
                    .map{
                        $0.amount
                    }
                    .reduce(0) { $0 + $1}
                    .eraseToAnyPublisher()
            }
            .sink { transactionsAmount in
                let remaining = self.cardUser.monthAllowedBudget - transactionsAmount
                self.budgetLeft = remaining
            }
            .store(in: &subsriptions)
        
        
    }
    
    func selectCard(_ cardModel : CardModel){
        selectedCardEvent.send(cardModel)
    }
    
    func unselectCar(){
        selectedCardEvent.send(CardModel(cardData: .init(name: "")))
    }
    
    func getTransactions(){
        cardModel
            .publisher
            .flatMap { model in
                model.cardData.transaction
                    .publisher
                    .map { transaction in
                        ExpenseGraphModel(
                            transaction: transaction,
                            cardColor: .creditCardColor(model.cardData),
                            cardNumber: model.cardData.cardNumber
                        )
                    }
                    .eraseToAnyPublisher()
            }
            .collect()
            .sink(receiveValue: { result in
                self.expensesGraphData = result.sorted(by: {$0.transaction.date < $1.transaction.date})
            })
            .store(in:&subsriptions)
    }
    
    func findSelectedPaymentsForDate(_ date : String){
        cardModel
            .publisher
            .flatMap { card in
                card.cardData.transaction
                    .publisher
                    .filter{$0.dayDateString == date}
                    .map {_ in
                        return card
                    }
                    .eraseToAnyPublisher()
            }
            .collect()
            .assign(to: &$cardUsedForPayment)
    }
    
}

struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
