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

            let learnQuotes = vm.learnQuotesLoadable.valueOrEmpty
            if learnQuotes.isEmpty {
                emptyLearnQuoteView

            } else {

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

    var emptyLearnQuoteView: some View {
        VStack(spacing: 20) {
            Image("victory")
                .resizable()
                .mask(
                    RoundedRectangle(cornerRadius: 10)
                )
                .frame(width: getRect().width * 0.65, height: 200)
                .scaledToFit()
                .shadow(color: .white.opacity(0.8), radius: 25, x: 8, y: 25)

            moreButton

            Spacer()
        }
        .padding(50)

    }

    var moreButton: some View {
        Button {
            vm.generateLearnQuotes(force: false)

        } label: {
            Text("More".uppercased())
        }
        .buttonStyle(
            NiceButtonStyle(
                foregroundColor: .secondTheme.accent,
                backgroundColor: .secondTheme.background,
                padding: EdgeInsets(top: 10, leading: 35, bottom: 10, trailing: 35))
        )
    }

}

struct LearnListView_Previews: PreviewProvider {
    static var previews: some View {
        LearnListView()
            .background(Color.theme.backgroundView)
    }
}
