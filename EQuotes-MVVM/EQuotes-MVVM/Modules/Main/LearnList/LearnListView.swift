//
//  LearnListView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 21/04/2023.
//

import SwiftUI

struct LearnListView: View {
    @StateObject var vm = LearnListViewModel()

    var body: some View {
        VStack {
            infoHeaderView

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .center, spacing: 20) {
                    ForEach(vm.learnQuotesLoadable.valueOrEmpty) { quoteItem in
                        LearnQuoteCardView(quoteItem: quoteItem)
                            .environmentObject(vm)
                            .task {
                                await vm.autoFillHintIfNeeded(item: quoteItem)
                            }

                    }

                }

                Spacer(minLength: 20)
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
