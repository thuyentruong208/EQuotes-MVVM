//
//  HintCardView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import SwiftUI

struct HintCardView: View {

    var quoteItem: QuoteItem
   
    var body: some View {
        VStack {
            hintText
            hintImagesView
        }
        .frame(maxWidth: .infinity)
        .modifier(CardStyleViewModifier(
            backgroundColor: .theme.hintCardBackground,
            accent: .theme.hintCardAccent)
        )
    }
}

private extension HintCardView {

    var hintText: some View {
        VStack {
            if let askContent = quoteItem.ask, !askContent.isEmpty {
                Text(askContent)
                    .multilineTextAlignment(.center)

            }
        }
    }

    var hintImagesView: some View {
        let images = quoteItem.images?.split(separator: ",").map(String.init) ?? []

        return HStack {
            ForEach(images, id: \.self) { (image) in
                AsyncImage(url: URL(string: image)) { (phrase) in
                    switch phrase {
                    case .empty:
                        ProgressView()

                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 250, maxHeight: 250)
                    default:
                        Rectangle()
                            .frame(width: 100, height: 100)
                            .background(Color.gray)
                    }

                }
            }
        }
    }

}

struct HintCardView_Previews: PreviewProvider {
    static var previews: some View {
        HintCardView(quoteItem: MockData.quoteItem)
            .padding()
            .background(Color.theme.backgroundView)
            .previewLayout(.sizeThatFits)
    }
}
