//
//  AddOrUpdateView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 22/04/2023.
//

import SwiftUI

struct AddOrUpdateQuoteView: View {

    let titleScreen: String
    let showFrontCard: Bool
    @StateObject var newQuoteContent = NewQuoteContent()
    @StateObject var vm = AddOrUpateQuoteViewModel(dbManager: RealDatabaseManager())
    @Environment(\.dismiss) private var dismiss
    @State private var showCheckmark = false
    @State private var showError = false

    var body: some View {
        NavigationView {

            VStack(spacing: 16) {
                QuoteCardView(
                    for: newQuoteContent.toQuoteItem(),
                    showFrontCard: showFrontCard)

                Divider()

                addOrUpdateForm
            }
            .onChange(of: vm.addQuoteStatus, perform: onChangeAddQuoteStatus)
            .onChange(of: vm.updateQuoteStatus, perform: onChangeUpdateQuoteStatus)
            .padding(.horizontal, 16)
            .background(Color.secondTheme.background)
            .navigationTitle(titleScreen)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    leadingNavBarButton
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButton

                }
            }
        }
        .preferredColorScheme(.light)
    }

}

private extension AddOrUpdateQuoteView {
    var addOrUpdateForm: some View {
        Form {
            Section("Front") {
                TextField("e.g: <Quote>", text: $newQuoteContent.enContent, axis: .vertical)
                    .lineLimit(3...10)

                TextField("e.g: <Extra info>", text: $newQuoteContent.viContent, axis: .vertical)
                    .lineLimit(1...10)

            }

            Section("Back") {
                TextField("e.g: <Hint Text>", text: $newQuoteContent.hintContent, axis: .vertical)
                    .lineLimit(3...10)

                TextField("e.g: <imageURL>,<imageURL>", text: $newQuoteContent.hintImages, axis: .vertical)
                    .lineLimit(1...10)

            }
        }
    }

    var leadingNavBarButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .foregroundColor(.secondTheme.accent)
        }
    }

    var trailingNavBarButton: some View {
        HStack {
            ZStack {
                Image(systemName: "xmark.diamond.fill")
                    .opacity(showError ? 1 : 0)
                    .foregroundColor(Color.red)

                Image(systemName: "checkmark")
                    .opacity(showCheckmark ? 1 : 0)
                    .foregroundColor(Color.secondTheme.accent)
            }


            Button {
                UIApplication.shared.endEditing()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
                    .foregroundColor(.secondTheme.accent)
            }


            Button {
                saveButtonPressed()

            } label: {
                Text("Save".uppercased())
                    .foregroundColor(.secondTheme.accent)
            }
            .opacity(
                newQuoteContent.enContent.isEmpty ? 0 : 1
            )
        }
        .font(.headline)
    }

    func saveButtonPressed() {
        showError = false
        let item = newQuoteContent.toQuoteItem()

        item.id == nil ? // Add
            vm.addQuote(item: item) :
            vm.updateQuote(item: item)
    }

    func flashCheckmarkIcon(_ afterFlash: @escaping () -> Void) {
        withAnimation(.easeIn) {
            showCheckmark = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }

            afterFlash()
        }
    }


    func onChangeAddQuoteStatus(value: Loadable<Bool>) -> Void {
        switch value {
        case .loaded:
            flashCheckmarkIcon {
                newQuoteContent.clear()
                vm.addQuoteStatus = .notRequested
            }

        case .failed:
            showError = true

        default:
            break
        }
    }

    func onChangeUpdateQuoteStatus(value: Loadable<Bool>) -> Void {
        switch value {
        case .loaded:
            flashCheckmarkIcon {
                dismiss()
            }

        case .failed:
            showError = true

        default:
            break
        }
    }
}

struct AddOrUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        AddOrUpdateQuoteView(titleScreen: "Add Quote", showFrontCard: true)
            .background(Color.black)
    }
}
