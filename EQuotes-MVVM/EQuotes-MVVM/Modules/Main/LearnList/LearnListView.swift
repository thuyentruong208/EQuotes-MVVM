//
//  LearnListView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 21/04/2023.
//

import SwiftUI

struct LearnListView: View {
    @StateObject var vm = LearnListViewModel(dbManager: RealDatabaseManager())

    var body: some View {
        VStack {
            infoHeaderView

            ScrollView(.vertical, showsIndicators: false) {

                LazyVStack(alignment: .center, spacing: 20) {
                    ForEach(vm.learnQuotesLoadable.valueOrEmpty) { quoteItem in
                        QuoteCardView(quoteItem: quoteItem)
                    }

                }
            }
        }
    }
}

private extension LearnListView {
    var infoHeaderView: some View {
        HStack(spacing: 0) {
            Text(vm.toDateLoadable.value??.formatted() ?? "")
                .font(.caption)

            Text(" || ")

            Text("\(vm.learnQuotesCount)")
                .font(.footnote)

        }
        .foregroundColor(.theme.accent)
        .frame(maxWidth: .infinity, alignment: .leading)

    }
}

struct LearnListView_Previews: PreviewProvider {
    static var previews: some View {
        LearnListView()
            .background(Color.theme.backgroundView)
    }
}
