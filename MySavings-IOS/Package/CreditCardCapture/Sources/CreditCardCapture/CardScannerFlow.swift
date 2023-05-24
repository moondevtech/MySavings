    //
    //  CardScannerView.swift
    //  MySavings-IOS
    //
    //  Created by Ruben Mimoun on 21/05/2023.
    //

import SwiftUI

public struct CardScannerFlow: View {
    
    @StateObject var viewModel: CaptureState = .init()
    @FocusState var focusField: CaptureState.CaptureValue?
    
    @Binding var showCaptureFlow: Bool

    public var onFinish : (CaptureState.Extracted) -> Void
    
    public init (
        showCaptureFlow: Binding<Bool>,
        onFinish: @escaping (CaptureState.Extracted) -> Void) {
        self.onFinish = onFinish
        self._showCaptureFlow =  showCaptureFlow
    }
    
    public var body: some View {
        NavigationStack(path: $viewModel.path) {
            ScannerView()
                .environmentObject(viewModel)
                .navigationDestination(for: UIImage.self) { image in
                    CardExtractorScreen(scannedImage: image)
                }
        }
    }
    
    @ViewBuilder
    func ScannerView() -> some View {
        CardScannerView()
            .overlay(alignment: .topLeading) {
                Button {
                    showCaptureFlow = false
                } label: {
                   Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
                .padding(20)
            
            }
    }
    
    @ViewBuilder
    func CardExtractorScreen(scannedImage: UIImage) -> some View {
        List {
            CardTextExtractorView(viewModel: viewModel, scannedImage: scannedImage)
                .environmentObject(viewModel)
                .frame(height: 300)
                        
            SelectionButton(viewModel: viewModel, captureValue: .cardNumber)
            
            SelectionButton(viewModel: viewModel, captureValue: .name)
            
            SelectionButton(viewModel: viewModel, captureValue: .date)
        }
        
        .toolbar {
            if viewModel.isFulfilled {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        onFinish(viewModel.extracted)

                        showCaptureFlow  = false
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.green)
                    }
                }
            }
        }
        .animation(.spring(), value: viewModel.isFulfilled)
        .scrollDisabled(true)
    }
    
    
    struct SelectionButton: View  {
        
        struct CardContent {
            var title: String
            var content: String
            var systemName: String
        }
        
        @ObservedObject var viewModel: CaptureState
        var captureValue: CaptureState.CaptureValue
        @State var movingBorder: Double = 0
        @State var rotation: (CGFloat, CGFloat, CGFloat)  = (0, 0, 0)
        
        var body: some View {
            
            var cardContent: CardContent
            
            switch captureValue {
                case .cardNumber:
                    cardContent = .init(title: "Card number", content: viewModel.extractedNumber, systemName: "creditcard")
                case .name:
                    cardContent = .init(title: "Card holder", content: viewModel.extractedName, systemName: "person")
                case .date:
                    cardContent = .init(title: "Expiration date", content: viewModel.extractedDate, systemName: "calendar")
            }
            
            return  HStack{
                Spacer()
                
                Button {
                    viewModel.captureState = captureValue
                    movingBorder = 1.0
                } label: {
                    HStack{
                        
                        VStack{
                            TitleView(cardContent.systemName, title: cardContent.title)
                                .transition(.move(edge: .leading))
                            
                            if !cardContent.content.isEmpty {
                                Text(cardContent.content)
                                    .foregroundColor(Color.gray)
                                    .padding(.top)
                            }
                        }
                        
                        Spacer()
                        
                        if viewModel.captureState == captureValue {
                            Image(systemName: "star.fill")
                                .symbolRenderingMode(.multicolor)
                                .transition(.scale)
                                .scaleEffect(0.8)
                        }
                    }
                }
                Spacer()
            }
            .onAppear {
                viewModel.extracted = .init()
            }
            .animation(.spring(), value: viewModel.captureState)
        }
        
        @ViewBuilder
        func TitleView(_ systemName: String, title: String) -> some View {
            HStack{
                Text(title)
                    .foregroundColor(Color.gray)
                    .font(.caption2)
                
                Image(systemName: systemName)
                    .transition(.scale)
                    .scaleEffect(0.8)
                
                Spacer()
            }
        }
    }
}

fileprivate extension TextField {
    
    func shaped() -> some View {
        return   self
            .foregroundColor(Color.white)
            .background(Color.white.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(height: 50)
            .padding()
        
    }
    
}

struct CardScannerFlow_Previews: PreviewProvider {
    static var previews: some View {
        CardScannerFlow(showCaptureFlow: .constant(false), onFinish: { _ in })
            .preferredColorScheme(.dark)
    }
}
