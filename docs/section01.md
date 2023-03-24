# Section 01 : API 仕様の合意

ここでは Todo リストを管理する API を設計します。

## データの定義

まず 1つの Todo アイテムを表すデータは以下のようになるものとします。

- 一意に識別するための `id`
- 題名を表す `title`
- 具体的な作業内容を表す `task`
- 有効、完了等の状態を表す `status`
- 締め切りを表す `duedate`
- 最終更新日時を表す `updatedOn`

```json
{
    "id": 100,
    "title": "Task1",
    "task": "経費を清算する",
    "status": "Active",
    "duedate": "2023-03-20T08:14:05.0872495+00:00",
    "updatedOn": "2023-03-14T08:14:05.0872065+00:00"
}
```

## 操作の定義

API では上記で定義した Todo を扱うために必要な以下の操作を提供するものとします、

|Path|Method|意味|
|---|---|---|
|/todo/v1|GET|登録されている全ての Todo アイテムを取得する|
|/todo/v1|POST|Todo アイテム新規に登録する|
|/todo/v1/{id}|GET|指定した id に該当する Todo を 1 件取得する|
|/todo/v1/{id}|PUT|指定した id に該当する Todo の内容を変更する|
|/todo/v1/{id}|DELETE|指定した id に該当する Todo を削除する|

Power Apps キャンバスアプリはこれらの操作を使用してユーザーインタフェースを提供します。