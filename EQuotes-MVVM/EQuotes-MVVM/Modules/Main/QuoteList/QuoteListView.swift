//
//  QuoteListView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import SwiftUI

struct QuoteListView: View {
    @StateObject var vm = QuoteListViewModel()

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .center, spacing: 20) {
                ForEach(vm.quotesLoadable.valueOrEmpty) { quoteItem in
                    QuoteCardView(for: quoteItem, showFrontCard: true)
                }

            }
        }
    }
}

struct QuoteListView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteListView()
            .padding()
            .background(Color.theme.backgroundView)
    }
}
