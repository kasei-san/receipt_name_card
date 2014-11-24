receipt_name_card
=================

サーマルプリンタ([SparkFun COM-10438](http://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-4EWP))を使った名刺の出力サンプル


## データシート

- https://www.sparkfun.com/datasheets/Components/General/A2-user%20manual-1.pdf

## 実行方法

1. サーマルプリンタと、[USB・シリアル変換ケーブル](http://akizukidenshi.com/catalog/g/gM-05840/)を接続する
1. USB・シリアル変換ケーブル と、PC を接続する
1. /dev/ で認識された、USB・シリアル変換ケーブル を探す (/dev/tty.usbserial-FTGD4019 など)
1. 必要に応じて、main.rb のデバイス名を変更する
1. コマンド実行
```
$ ruby main.rb
```

## 出力例

![出力例](https://raw.githubusercontent.com/kasei-san/receipt_name_card/master/sample.png)
