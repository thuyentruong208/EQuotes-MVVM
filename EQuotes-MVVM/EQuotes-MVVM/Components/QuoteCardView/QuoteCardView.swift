//
//  QuoteCardView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import SwiftUI

struct QuoteCardView: View {

    let quoteItem: QuoteItem
    @State var showFrontCard = false

    var body: some View {
        ZStack {
            if showFrontCard {
                ShowCardView(quoteItem: quoteItem)
                    
            } else {
                HintCardView(quoteItem: quoteItem)
                    
            }
        }
        .frame(maxWidth: 500)
        .onTapGesture {
            withAnimation(.linear(duration: 0.25)) {
                showFrontCard.toggle()
            }
        }

    }
}

struct QuoteCardView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteCardView(quoteItem: MockData.quoteItem)
            .padding()
            .background(Color.black)
            .previewLayout(.sizeThatFits)
            
    }
}
