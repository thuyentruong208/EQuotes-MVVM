//
//  LearnQuoteCardView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 22/04/2023.
//

import SwiftUI

struct LearnQuoteCardView: View {
    @EnvironmentObject var vm: LearnListViewModel
    @State var xOffset: CGFloat = 0
    let quoteItem: QuoteItem

    var body: some View {
        QuoteCardView(for: quoteItem, showFrontCard: false)
            .offset(x: xOffset)
            .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
                .onEnded({ value in
                    print(value.translation.width )
                    if value.translation.width > 80 {
                        xOffset = 1000
                        vm.markAsDone(item: quoteItem)
                    } else {
                        xOffset = 0
                    }
                })
                    .onChanged({ value in
                        xOffset = value.translation.width
                    })
                     )
    }
}

struct LearnQuoteCardView_Previews: PreviewProvider {
    static var previews: some View {
        LearnQuoteCardView(quoteItem: MockData.quoteItem)
    }
}
