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
    // SafariViewの表示有無を管理する変数
    @State var showSafari = false
    
    var body: some View {
        VStack {
            // 文字を受け取るTextFieldを表示する
            TextField("キーワード",
                      text: $inputText,
                      prompt: Text("キーワードを入力してください")
            )
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
            
            // リスト表示
            List(okashiDataList.okashiList) { okashi in
                // ボタンを用意
                Button {
                    showSafari.toggle()
                } label: {
                    // Listの表示内容を生成する
                    HStack {
                        // 画像読み込み表示
                        AsyncImage(url: okashi.image) { image in
                            // 画像表示
                            image
                                // リサイズ
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 40)
                        } placeholder: {
                            // 読み込み中はインジケータ
                            ProgressView()
                        }
                        // テキスト表示する
                        Text(okashi.name)
                    }
                }
                .sheet(isPresented: self.$showSafari, content: {
                    // SafariView表示
                    SafariView(url: okashi.link)
                        // 画面下部がセーフエリア外までいっぱいになるように指定
                        .edgesIgnoringSafeArea(.bottom)
                })
            }
        }
        
    }
}

#Preview {
    ContentView()
}
