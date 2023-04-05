# Section ２０ : API のメジャー　バージョンアップ

**本セクションは応用編です。詳細な手順は記載しておりませんが、時間のある方はチャレンジしてみてください。**

ここまで Todo 一覧を取得するだけの API を公開、キャンバスアプリから利用してきました。
ここでは、Todo 一覧を取得するだけではなく、Todo の追加、更新、削除も行えるように API を拡張します。

## API 仕様の変更

[Section 01](./section01.md)で設計した API 仕様は例えば [こちら](./todo-api-spec.json) のようになります。
仕様が大きく変わりますので、メジャーバージョンを上げて新しいバージョンの API を公開すると良いでしょう。

## Todo API v2 の定義

作成した API v1 のメニューから `Add version` を選択することで、新しいバージョンの API を作成できます。
Vertion Identifier を v2 として作成すると、v1 と v2 の両方の API が動作する状態になります。
作成直後は v2 は v1 と同じ仕様、同じ設定になっています。

## API 仕様のインポート

v2 の API を一から作成しても良いのですが、すでに定義済みの仕様書がありますので、`Import` を選択して仕様書をインポートすることができます。

## バックエンド API の実装

[Section 07](./section07.md) で App Service にデプロイした API は、一覧取得だけでなく、作成や更新といった各種操作が実装済みです。
このため Web service URL に v1 と同じ URL を入力するとそのまま動作させることが可能です。

```
https://web-fusiondev-${Prefix}-MMdd.azurewebsites.net/todos/v1
```

API Management で公開している API が v2 なのに、バックエンド API が v1 なのは奇妙な感じもしますが、
市民開発者向けに公開する API のライフサイクルと、バックエンドシステムとして管理している API のライフサイクルは異なることがありますので、
こういったケースもありえるのではないでしょうか。

## カスタムコネクタの作成

API がバージョンアップして v1 と v2 が並行稼働している状態なので、対応するカスタムコネクタも v1 とは別に v2 用のものを新規に作成します。
API v1 用のカスタムコネクタを編集して仕様変更してしまうと、既にそれを利用しているキャンバスアプリに影響が出てしまう可能性があります。

## キャンバスアプリの機能追加

キャンバスアプリの機能を追加して、Todo の追加、更新、削除ができるようにしてみましょう。

例えば更新操作を行うための関数は下記のような実装になります。

```
TodoAPI.updatetodobyid(
    IdInput.Text, 
    {   
        id_1:IdInput.Text, 
        title:TitleInput.Text, 
        task:TaskInput.Text, 
        status: If(StatusCheckbox.Value, "Done", "Active"), 
        duedate: DuedatePickder.SelectedDate, updatedOn: Now()
    }
);
```