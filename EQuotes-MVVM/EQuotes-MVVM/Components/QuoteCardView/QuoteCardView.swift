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
    @State var showEditQuoteView = false

    init(for quoteItem: QuoteItem, showFrontCard: Bool) {
        self.quoteItem = quoteItem
        self._showFrontCard = State(initialValue: showFrontCard)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    updateButton
                    speakButton
                }
                .padding(.bottom, 8)

                if showFrontCard {
                    ShowCardView(quoteItem: quoteItem)

                } else {
                    HintCardView(quoteItem: quoteItem)

                }
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

private extension QuoteCardView {
    var updateButton: some View {
        Button {
            showEditQuoteView.toggle()
        } label: {
            Image(systemName: "square.and.pencil.circle")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(Color.white)

        }
        .sheet(isPresented: $showEditQuoteView) {
            AddOrUpdateQuoteView(
                titleScreen: "Update Quote",
                showFrontCard: showFrontCard,
                newQuoteContent: NewQuoteContent(quoteItem: quoteItem)
            )
        }
    }

    var speakButton: some View {
        Button {
            AVHelper.shared.speak(text: quoteItem.en)

        } label: {
            Image(systemName: "speaker.wave.2.fill")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(.theme.accent)
        }

    }

}

struct QuoteCardView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteCardView(for: MockData.quoteItem, showFrontCard: true)
            .padding()
            .background(Color.black)
            .previewLayout(.sizeThatFits)
            
    }
}
