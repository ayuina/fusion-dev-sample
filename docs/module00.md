# Module 0 : ハンズオンラボの環境準備

## はじめに

ハンズオンラボの参加者は以下のような環境を共有して作業を実施します。

- Azure AD テナント
    - 参加人数分のユーザーが登録されている単一の Azure AD テナントを使用します
    - Azure 
- Azure サブスクリプション
    - 上記の Azure AD　テナントに紐つけられた単一の Azure サブスクリプションを参加者で共同利用します
    - 代表者は Owner ロールに割り当てられ、参加者全員が Contributor　ロールに割り当てられているものとします
- Power Apps ライセンス
    - [Power Apps 開発者向けプラン](https://powerapps.microsoft.com/ja-jp/developerplan/)を使用します

![](./images/mod00-overview.png)

## 環境の構築手順

ハンズオン環境の構築手順は[こちらの記事](https://ayuina.github.io/ainaba-csa-blog/microsoft-cloud-trial/)を参考にしてください。

## API Management の作成

このハンズオンでは全参加者で共通の API Management を利用します。

- **API Management の構築は一時間程度かかりますが** 実際に使用するのは Module 3 ですので、当日の朝や Module 1 の開始前に実施してください
- 構築するとすぐに課金が始まってしまいますので、前日等に作業する場合はフリープランのクレジットを使い切らないように注意してください