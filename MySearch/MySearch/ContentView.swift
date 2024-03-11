//
//  ContentView.swift
//  MySearch
//
//  Created by 河田佳之 on 2024/03/08.
//

import SwiftUI

struct ContentView: View {
    // OkashiDataを参照する状態変数
    @StateObject var okashiDataList = OkashiData()
    // 入力された文字列を保持する状態変数
    @State var inputText = ""
    
    var body: some View {
        VStack {
            // 文字を受け取るTextFieldを表示する
            TextField("キーワード",
                      text: $inputText,
                      prompt: Text("キーワードを入力してください"))
                .onSubmit {
                    // Taskは非同期で処理を実行できる
                    Task {
                        // 入力完了直後に検索する
                        await okashiDataList.searchOkashi(keyword: inputText)
                    }
                }
                // キーボードの改行を検索に変更する
                .submitLabel(.search)
                .padding()
        }
        
    }
}

#Preview {
    ContentView()
}
