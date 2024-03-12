//
//  SafariView.swift
//  MySearch
//
//  Created by 河田佳之 on 2024/03/12.
//

import SwiftUI
import SafariServices

// SFSafariViewControllerを起動する構造体
struct SafariView: UIViewControllerRepresentable {
    // ホームページのURL
    var url: URL
    
    // 表示するViewを生成するときに実行
    func makeUIViewController(context: Context) -> SFSafariViewController {
        // Safariを起動
        return SFSafariViewController(url: url)
    }
    
    // Viewが更新されたときに実行
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // 処理無し
    }
}

