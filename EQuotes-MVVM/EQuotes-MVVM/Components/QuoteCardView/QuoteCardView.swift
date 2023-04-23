//
//  QuoteCardView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import SwiftUI

struct QuoteCardView: View {

    let quoteItem: QuoteItem
    let supportFunctions: Bool
    @State var showFrontCard = false
    @State var showEditQuoteView = false

    init(for quoteItem: QuoteItem, supportFunctions: Bool = true, showFrontCard: Bool) {
        self.quoteItem = quoteItem
        self.supportFunctions = supportFunctions
        self._showFrontCard = State(initialValue: showFrontCard)
    }

    var body: some View {
        ZStack {
            if supportFunctions {
                layoutedContent
            } else {
                quoteCardView
            }
        }
        .onTapGesture {
            withAnimation(.linear(duration: 0.25)) {
                showFrontCard.toggle()
            }
        }

    }
}

private extension QuoteCardView {
    var layoutedContent: some View {
        if getRect().width <= 400 {
            return AnyView(
                VStack(spacing: 0) {
                    HStack(spacing: 16) {
                        updateButton
                        speakButton
                    }
                    .padding(.bottom, 8)

                    quoteCardView
                })
        } else {
            return AnyView(
                HStack(spacing: 20) {
                    quoteCardView

                    VStack(spacing: 16) {
                        updateButton
                        speakButton
                    }
                })
        }
    }

    var quoteCardView: some View {
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

    var updateButton: some View {
        Image(systemName: "square.and.pencil.circle")
            .resizable()
            .frame(width: 25, height: 25)
            .foregroundColor(Color.white)
            .onTapGesture {
                showEditQuoteView.toggle()
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
        Image(systemName: "speaker.wave.2.fill")
            .resizable()
            .frame(width: 22, height: 22)
            .foregroundColor(.theme.accent)
            .onTapGesture {
                AVHelper.shared.speak(text: quoteItem.en)
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
