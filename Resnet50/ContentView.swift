//
//  ContentView.swift
//  Resnet50
//
//  Created by Nakanishi Toshihiko on 2021/05/30.
//

import SwiftUI
import CoreML
import Vision

struct ContentView: View {
    @State var 予測を格納する変数 = ""
    //リクエストを作る処理
    func リクエストを作る関数() -> VNCoreMLRequest  {
        do {
            let モデルの設定インスタンス = MLModelConfiguration()
            let モデルのインスタンス = try VNCoreMLModel(for: Resnet50(configuration: モデルの設定インスタンス).model)
            let リクエスト = VNCoreMLRequest(model: モデルのインスタンス,completionHandler: {リクエスト結果,エラー結果 in
                画像分類リクエスト処理関数(画像分類リクエスト: リクエスト結果)
            })
            return リクエスト
        } catch {
            fatalError("modelが読み込めません")
        }
    }
    //画像分類の処理
    func 画像分類リクエスト処理関数(画像分類リクエスト:VNRequest) {
        guard let nil判定 = 画像分類リクエスト.results else {
            return
        }
        let 予測情報の変数 = nil判定 as! [VNClassificationObservation]
        予測を格納する変数 = 予測情報の変数[0].identifier
        //[0]は予測情報が一番高い結果
        //identifierメソッドでラベルの情報のみ（確率等他の情報は不要）取り出す
    }
    
    // 実際に画像を分類する
    func 画像分類処理関数(イメージ: UIImage) {
        //入力された画像の型をUIImageからCIImage型に変換
        guard let CIImageに変換 = CIImage(image: イメージ) else {
            fatalError("CIImageに変換できません")
        }
        // ハンドラーを作る
        let ハンドラー = VNImageRequestHandler(ciImage: CIImageに変換)
        // ハンドラーに渡すリクエストを作成
        let ハンドラーに渡すリクエスト = リクエストを作る関数()
        // ハンドラーを実行する
        do {
            try ハンドラー.perform([ハンドラーに渡すリクエスト])
        } catch {
            fatalError("画像分類に失敗しました")
        }
    }
    
    var body: some View {
        VStack {
            Text(予測を格納する変数)
                .padding()
                .font(.title)
            Image("cat")
                .resizable()
                .frame(width: 300, height: 200)
            Button(action: {
                画像分類処理関数(イメージ: UIImage(named: "cat")!)
            }, label: {
                Text("この画像は何の画像？")
                    .padding()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
