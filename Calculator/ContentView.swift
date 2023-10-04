//
//  ContentView.swift
//  Calculator
//
//  Created by 张小东 on 2023/9/27.
//

import SwiftUI

let scale = UIScreen.main.bounds.size.width / 414

struct ContentView: View {
    
//    @State private var brain: CalculatorBrain = .left("0")
//    @ObservedObject var model = CalculatorModel()
    @EnvironmentObject var model: CalculatorModel
    @State private var editingHistory = false
    var body: some View {
        VStack(spacing: 12, content: {
            Spacer()
            Button("操作履历：\(model.history.count)") {
//                print(self.model.history)
                self.editingHistory = true
            }.sheet(isPresented: self.$editingHistory, content: {
                HistoryView(model: self.model)
            })
            Text(model.brain.output)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24 * scale)
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, alignment: .trailing)
//            Button("Test") {
//                self.brain = .left("1.23")
//            }
//            CalculatorButtonPad(model: model).padding(.bottom)
            CalculatorButtonPad().padding(.bottom)
        })
    }
}

struct CalculatorButton: View {
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let backgroundColorName: String
    let foregroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text(title)
                .foregroundStyle(foregroundColor)
                .font(.system(size: fontSize * scale))
                .frame(width: size.width * scale, height: size.height * scale)
                .background(Color(backgroundColorName))
                .clipShape(Capsule())
        })
    }
}

struct CalculatorButtonRow: View {
//    @Binding var brain: CalculatorBrain
//    var model: CalculatorModel
    @EnvironmentObject var model: CalculatorModel
    let row: [CalculatorButtonItem]
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(
                    title: item.title,
                    size: item.size,
                    backgroundColorName: item.backgroundColorName,
                    foregroundColor: item.foregroundColor) {
//                        self.brain = self.brain.apply(item: item)
                        self.model.apply(item)
                }
            }
        }
    }
}

struct CalculatorButtonPad: View {
//    @Binding var brain: CalculatorBrain
//    var model: CalculatorModel
    let pad: [[CalculatorButtonItem]] = [
        [.command(.clear), .command(.flip), .command(.percent), .op(.divide)],
        [.digit(7), .digit(8), .digit(9), .op(.multiply)],
        [.digit(4), .digit(5), .digit(6), .op(.minus)],
        [.digit(1), .digit(2), .digit(3), .op(.plus)],
        [.digit(0), .dot, .op(.equal)]
    ]
    var body: some View {
        VStack(spacing: 8, content: {
            ForEach(pad, id: \.self) { row in
//                CalculatorButtonRow(model: model, row: row)
                CalculatorButtonRow(row: row)
            }
        })
    }
}

struct HistoryView: View {
    @ObservedObject var model: CalculatorModel
    var body: some View {
        VStack {
            if model.totalCount == 0 {
                Text("没有履历")
            } else {
                HStack {
                    Text("履历").font(.headline)
                    Text("\(model.historyDetail)").lineLimit(nil)
                }
                HStack {
                    Text("显示").font(.headline)
                    Text("\(model.brain.output)")
                }
                Slider(value: $model.slidingIndex, in: 0...Float(model.totalCount), step: 1)
            }
        }.padding()
    }
}

#Preview {
    ContentView().environmentObject(CalculatorModel())
}
