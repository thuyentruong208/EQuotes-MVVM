//
//  QuoteListView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import SwiftUI

struct QuoteListView: View {
    @StateObject var vm = QuoteListViewModel(dbManager: RealDatabaseManager())

    var body: some View {
        LazyVStack(alignment: .center, spacing: 20) {
            ForEach(vm.quotesLoadable.valueOrEmpty) { quoteItem in
                Text(quoteItem.en)
            }

        }

    }
}

struct QuoteListView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteListView()
    }
}
