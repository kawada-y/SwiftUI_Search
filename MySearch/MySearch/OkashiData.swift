//
//  OkashiData.swift
//  MySearch
//
//  Created by 河田佳之 on 2024/03/08.
//

import Foundation
import UIKit

// Identifiableプロトコルを利用して、お菓子の情報をまとめる構造体
struct OkashiItem: Identifiable {
    let id = UUID()
    let name: String
    let link: URL
    let image: URL
}

// お菓子データ検索用クラス
class OkashiData: ObservableObject {
    
    struct ResultJson: Codable {
        // 要素
        let item: [Item]?
        
        // JSONのitem内のデータ構造
        struct Item: Codable {
            // お菓子の名称
            let name: String?
            // 掲載URL
            let url: URL?
            // 画像URL
            let image: URL?
        }
    }
    
    // お菓子のリスト（Identifiableプロトコル）
    @Published var okashiList: [OkashiItem] = []
    
    // Web API検索用メソッド
    func searchOkashi(keyword: String) async {
        // デバッグ出力
        print(keyword)
        
        // お菓子の検索キーワードをURLエンコードする
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        // リクエストURL
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
                return
        }
        print(req_url)
        
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)
            
            // JSONDecoderのインスタンス取得
            let decoder = JSONDecoder()
            // 受け取ったJSONデータをパースして格納
            let json = try decoder.decode(ResultJson.self, from: data)
            
            // print(json)
            
            // お菓子の情報が取得できているか確認
            guard let items = json.item else { return }
            // @Publishedの変数を更新するときはメインスレッドで更新する必要がある
            DispatchQueue.main.async {
                // お菓子のリストの初期化
                self.okashiList.removeAll()
            }
            // 取得しているお菓子の数だけ処理
            for item in items {
                // お菓子の名称、掲載URL、画像URLをアンラップ
                if let name = item.name,
                   let link = item.url,
                   let imageUrl = item.image {
                    // 1つのお菓子を構造体でまとめて管理
                    let okashi = OkashiItem(name: name, link: link, image: imageUrl)
                        // @Publishedの変数を更新するときはメインスレッドで更新する
                    DispatchQueue.main.async {
                        // お菓子の配列へ追加
                        self.okashiList.append(okashi)
                    }
                }
            }
            print(self.okashiList)
        } catch {
            // エラー
            print("エラー")
        }
    }
}
