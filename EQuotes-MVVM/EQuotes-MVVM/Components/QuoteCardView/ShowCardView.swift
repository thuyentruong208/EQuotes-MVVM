//
//  ShowCardView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import SwiftUI

struct ShowCardView: View {

    var quoteItem: QuoteItem

    var body: some View {
        VStack {
            quoteText
            extraInfoText

        }
        .frame(maxWidth: .infinity)
        .modifier(CardStyleViewModifier(
            backgroundColor: .theme.showCardBackground,
            accent: .theme.showCardAccent)
        )
    }
}

private extension ShowCardView {
    var quoteText: some View {
        Text(quoteItem.en.markdownToAttributed())
            .padding(.vertical, 5)
            .multilineTextAlignment(.center)
    }

    var extraInfoText: some View {
        VStack {
            if let viText = quoteItem.vi, !viText.isEmpty {
                Divider()
                    .background(Color.black)

                Text(viText.markdownToAttributed())
                    .padding(.vertical, 5)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
            }
        }
    }

}

struct ShowCardView_Previews: PreviewProvider {
    static var previews: some View {
        ShowCardView(quoteItem: MockData.quoteItem)
            .padding()
            .background(Color.theme.backgroundView)
            .previewLayout(.sizeThatFits)
    }
}
