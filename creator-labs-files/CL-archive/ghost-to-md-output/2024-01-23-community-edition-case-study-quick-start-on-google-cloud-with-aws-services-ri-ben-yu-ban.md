---
title: "Community Edition Case Study: Quick Start on Google Cloud with AWS Services 日本語版"
slug: community-edition-case-study-quick-start-on-google-cloud-with-aws-services-ri-ben-yu-ban
date_published: 2024-01-23T16:20:21.000Z
date_updated: 2024-01-23T16:20:21.000Z
tags: Advanced, Tutorials
excerpt: Documentation Awardee Kojiro Yano translates Mozilla's quick start guide to Community Edition on GCP.
---

---

> [!IMPORTANT]
> **Editor's Note:** This article is based on the bash version of Community Edition, to follow along you will need to use the bash scripts from https://github.com/Hubs-Foundation/hubs-cloud/tree/bash-version

本ブログポストは、Hubs Creator Labs に掲載された **[Community Edition Case Study: Quick Start on Google Cloud with AWS Services](__GHOST_URL__/community-edition-case-study-quick-start-on-gcp-w-aws-services/)**の日本語版です。日本語訳に加えて、筆者が有用と考えた情報を追記しています。

本文に入る前に軽く自己紹介。 私、[やのせん](https://twitter.com/yanosen_jp)は情報系学部の大学教員で、現在の主な専門分野は教育工学、特に VR やメタバースを活用した教育です。今回の Community Edition の前身である Hubs Cloud については、操作方法などを追加したものを個人で運用して、実際の授業で活用してきました。
![](./content/images/2024/01/Untitled-2.png)
残念ながら[Hubs Cloud がディスコンになることを受けて、Community Edition に移行予定](__GHOST_URL__/welcoming-community-edition/)です。

今回の Community Edition では新たに Docker や Kubernetes といった技術が使われていますが、自分は使用経験が無かったので正直少々戸惑いました。それでも、上記の Quick Start を参考にして自分用のサーバーを設置出来ました。その経験を参考に、以下の日本語版を作成しています。ご活用いただければ幸いです。もし質問がある時は、Discord(yanosen_jp)か Twitter(現 X)(@yanosen_jp)でメッセージください。分かる範囲でお答えします。

---

# はじめに

このステップバイステップガイドでは、AWS の Route53 と Simple Email Service (SES)を使用して Google Cloud に[Hubs Community Edition](https://github.com/mozilla/hubs-cloud/tree/feature/ce/community-edition)のインスタンスを迅速にデプロイする方法を学びます。AWS サービスの操作に慣れており、Google Cloud のような新しいプラットフォームで Hubs をホストする方法を学びたい Hubs Cloud の利用者の方に最適なガイドです。

始めるにあたっては、Community Edition や Kubernetes といった技術の基本情報とそれらがどのように連携して機能するかを理解することが重要です。既にこれらの情報を熟知している場合は、「[デプロイメントの必要事項](https://www.notion.so/Community-Edition-Case-Study-Quick-Start-on-Google-Cloud-with-AWS-Services-75e9c0b80b02465ba4178cca50b5a54d?pvs=21)」という小見出しからチュートリアルを開始しても構いません。

# Hubs Community Edition インフラストラクチャを理解する

"Mozilla Hubs" として知られる製品は、いくつかの強力なソフトウェアで構成されています。

例えば、ウェブブラウザで Hub を訪れた時、あなたは [Hubs クライアント](https://github.com/mozilla/hubs/)とインタラクションしています。

Hubs クライアント自体は、例えば以下のようないくつかの**他のソフトウェア**とやりとりします：

- [Reticulum](https://github.com/mozilla/reticulum) | Hubs のネットネットワークおよび API サーバー
- [Dialog](https://zachfox.io/hubs-webrtc-tester/about/) | Hubs の WebRTC 音声およびビデオ通信サーバー

Hubs クライアント、Dialog、および Reticulum は、より大きなソフトウェアスタックの 3 つのコンポーネントに過ぎません。このスタックの各コンポーネントは個別に設定され、Hubs が適切に機能するように他のコンポーネントとネットワークされています。

Hubs Community Edition は、開発者がスタックの各コンポーネントを個別にダウンロード、インストール、設定、接続、および更新する必要を無くしてくれます。Community Edition は、**コンテナ化されたソフトウェアオーケストレーションシステム**である **Kubernetes**と呼ばれるソフトウェアを使用して、その複雑なデプロイメントプロセスのほとんどを簡素化および自動化します。

# コンテナ化されたソフトウェアとは

この記事を読むにあたり、現在使用しているウェブブラウザを考えてみましょう：

1. そのブラウザが工場出荷時にデバイスにインストールされていない限り、あなたはまずデバイスのオペレーティングシステムに対応するブラウザのバージョンをダウンロードする必要がありましたね。
2. 次に、指定したディレクトリにアプリケーションファイルが配置されるようにブラウザをインストールしましたね。
3. その後、ブラウザを開き、Firefox アカウントまたは Google アカウントにサインインしたかもしれません。
4. そして、広告ブロッカーの拡張機能やパスワードマネージャーをインストールしたかもしれません。
5. 最後に、あなたはどこかのウェブサイトに行ってお気に入りバーに追加したかもしれませんね...

そこで、もしウェブブラウザのインストールの完全な状態をパッケージ化し、設定、ログインしているアカウント、拡張機能、ブラウザの履歴、お気に入りなどを含め、それをオペレーティングシステムに関係なく他のコンピュータで使用できるとしたら、どうですか？

同様に、**任意の**アプリケーションの完全な状態をパッケージ化し、その依存関係、ライブラリ、設定ファイル、およびアプリケーションコードを含め、そのパッケージを他のどのコンピュータでも実行できることを想像してみてください。

これは Docker と呼ばれるオープンソースソフトウェアを使用すれば**可能になります。Docker コンテナ**は、独自にパッケージされ設定されたソフトウェアを走らせる、コンピュータ上で実行されるプロセスです。Docker および Docker コンテナについては、[公式ドキュメント](https://docs.docker.com/get-started/)でより詳しく学んでください。

💡

最小限の設定で迅速なソフトウェアのデプロイを支援するために、セルフホスト型ソフトウェアが、Docker コンテナとして配布されることは一般的です。

Docker コンテナとしてパッケージされた人気ソフトウェアの他の例には以下のようなものがあります：
[Wordpress](https://hub.docker.com/_/wordpress) | ブログウェブサイトシステム
[Nextcloud](https://hub.docker.com/_/nextcloud) | コンテンツコラボレーションソフトウェアのスイート [Ubuntu](https://hub.docker.com/_/ubuntu) | すべての Linux ディストリビューション

**Hubs Community Edition の多くのコンポーネントは別々の Docker コンテナ内で実行されます**。これらのコンテナはそれ自体では互いについて多くを知りません。もし、Dialog コンテナも実行せずにコンピュータ上で Reticulum コンテナを実行した場合、Hub に接続した人は互いに見ることができますが、聞くことは**できません**。

したがって、これらのコンテナが互いに通信する方法が必要です。Hub に接続する人々がその Hub に関連する Dialog サーバーにも接続できるようにする方法が必要です。また、Reticulum コンテナを停止することなく Dialog コンテナのコードを更新する方法も必要です。これらすべてのコンテナをどのようにまとめるのでしょうか？

### **Kubernetes ならできます!**

# Kubernetes とは

Kubernetes（しばしば「K8s」と省略される）は、コンテナ化されたソフトウェアを**管理する**ためのシステムです。Kubernetes のデプロイメント、いわゆる「クラスタ」は、2 つの部分で構成されています：

1. 管理者や開発者によって定義されたクラスタの状態を維持する**コントロールプレーン**。
2. コントロールプレーンによって定義されたソフトウェアを実行する仮想または物理的なコンピュータである**ノード**。各ノードには、ストレージとネットワークリソースを共有する 1 つ以上の**ポッド**が含まれています。各ポッドは 1 つ以上の**コンテナ**を実行します。

![](./content/images/2024/01/Untitled-3.png)
Kubernetes を使用して構築されたソフトウェアをデプロイするためには、開発者はクラスタのポッド、それらのポッドのコンテナ、コンテナの機能に必要なコンピュータリソース、ネットワーク情報などを記述したプレーンテキストの設定ファイルとともに、Kubernetes の実行可能ファイルを提供する必要があります。この設定ファイルは[デプロイメント仕様](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment)と呼ばれます。

💡

たとえば、ある Hubs の開発者が、設定ファイルに「私の K8s クラスターには、ポート 9100 に Reticulum サーバのバージョン`ret.prod.220712.200`を、ポート 4443 に Dialog サーバのバージョン`dialog.prod.220303.63`を実行させたい」と記述するとしましょう。

コントロールプレーンはその設定ファイルを取り込み、指定のコンテナ化されたソフトウェアをノードにダウンロードして実行するよう指示します。

Kubernetes クラスターは、以下を含む多くの種類のコンピューターにデプロイ可能です：

- 自宅のデスクトップコンピューター
- [35 ドルの Raspberry Pi コンピューター 2 台](https://ubuntu.com/tutorials/how-to-kubernetes-cluster-on-raspberry-pi#1-overview)
- クラウドサービスプロバイダーが所有するコンピューター、例えば：
- [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine?hl=en)
- [Amazon Elastic Kubernetes Service](https://aws.amazon.com/eks/)
- [Microsoft Azure Kubernetes Service](https://azure.microsoft.com/en-us/products/kubernetes-service)
- [DigitalOcean Kubernetes](https://www.digitalocean.com/products/kubernetes)

# Community Edition のコンテナ化されたサービス

以下は、Hubs Community Edition を構成する各コンテナの概要です

1. [Hubs](https://github.com/mozilla/hubs/) | Web ブラウザ用の Hubs クライアント。
2. [Spoke](https://github.com/mozilla/spoke/) | Hubs 用のカスタム 3D 環境を作成するための Web ベースのコンテンツ作成ツール。
3. [Reticulum](https://github.com/mozilla/reticulum/) | Hubs のネットワーキングと API サーバー。認証、アバターの位置決め、オブジェクトの操作などを扱います。
4. [Dialog](https://github.com/mozilla/dialog/) | WebRTC オーディオおよびビデオ通信サーバー。これには WebRTC 選択的転送ユニットが含まれています。Hubs が WebRTC をどのように使用しているかの詳細については、[こちらの資料](https://zachfox.io/hubs-webrtc-tester/about/)をご覧ください。
5. [Coturn](https://github.com/coturn/coturn) | WebRTC 通信に使用される TURN および STUN サーバー。Hubs が WebRTC をどのように使用しているかの詳細については、[こちらの資料](https://zachfox.io/hubs-webrtc-tester/about/)をご覧ください。
6. [Nearspark](https://github.com/MozillaReality/nearspark) | 画像からサムネイルを生成するためのサービス。
7. [Speelycaptor](https://github.com/mozilla/speelycaptor) | 動画を Hubs 互換フォーマットに変換するサービス。ffmpeg を使用しています。
8. [PgBouncer](https://www.pgbouncer.org/install.html) | PostgreSQL の軽量なコネクションプーリングツール。新たに高コストな PostgreSQL データベース接続をクライアントやクエリごとに行うかわりに、コネクションプーラーはデータベースへの長寿命な接続グループを作成し、必要に応じてそれらの接続を再利用します。これによりデータベースアクセスのパフォーマンスと可用性が向上します。
9. [Photomnemonic](https://github.com/MozillaReality/photomnemonic) | ウェブサイトのスクリーンショットを撮るためのサービス。

ご自身の Community Edition をデプロイした後、これらのコンテナ化されたサービスが各々の個別のポッドで実行されているのが見られるようになります。ここで詳細な説明はおわりにしますので、デプロイメントチュートリアルに進みましょう！

# デプロイの必要事項

💡

このガイドを使っていて問題が起きた時、それを知らせる最も効果的な方法は、Discord サーバーの#community-edition チャンネルを利用するか、Hubs Cloud のリポジトリで issue を作成することです。

Community Edition を成功裏にデプロイするためには、一定の必須条件を満たす必要があります。以下で説明する要件は、このケーススタディに合わせて調整されており、Community Edition のコードベースと完全に一致するわけではありません。このチュートリアルは、macOS Ventura 13.1 を搭載した 2021 年モデルの M1 MacBook Pro を使用して作成されたことに注意してください。Community Edition をデプロイするために使用する個々のコマンドは、お使いのデバイスとオペレーティングシステムによって異なる場合があります。

**パート 1:** 始める前に、Amazon Web Services と Google Cloud Platform のアカウントで課金の設定を行う必要があります。このガイドではアカウントと請求情報の設定の個々のステップは説明しませんが、設定プロセスについての詳細は次のリンクで確認できます：[AWS](https://docs.aws.amazon.com/accounts/latest/reference/welcome-first-time-user.html) | [GCP](https://cloud.google.com/billing/docs/how-to/create-billing-account)

**パート 2**: 次の無料のサードパーティアプリケーションを使用します:

A. VSCode | Community Edition を設定しデプロイするためのコードエディター。

B. [Lens](https://k8slens.dev/) | K8s クラスターを監視し管理するためのインターフェース。

**パート 3**: コンピュータに以下のソフトウェアがインストールされていることを確認する必要があります。インストールに使用したコマンドも記載しています：

A. [Homebrew](https://brew.sh/)

    /bin/bash -c "$(curl -fsSL <https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh>)"

B. [The Google Cloud SDK](https://cloud.google.com/sdk?hl=en)

    brew install --cask google-cloud-sdk

C. [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)

    curl -LO "<https://dl.k8s.io/release/$>(curl -L -s <https://dl.k8s.io/release/stable.txt>)/bin/darwin/arm64/kubectl"

D. [gettext](https://www.gnu.org/software/gettext/)

    brew install gettext

# ステップ 1：AWS の Route53 で DNS を設定する

: AWS に Hubs Cloud インスタンスを設定したことがあるなら、Route53 でドメインを登録するプロセスはもうご存知でしょう。実際、Community Edition インスタンスで使用したい既存のドメインを持っているかもしれません。しかし、Hubs Cloud とは異なり、Community Edition をデプロイするためには**1 つ**の登録ドメインだけが必要です。

1. このデプロイメントに使用する予定のドメインを既に持っていない場合は、AWS Route53 で購入する必要があります：
2. AWS コンソールで Route53 に移動します。
3. 左側のツールバーで「登録済みドメイン」タブを選択します。
4. 「登録済みドメイン」ボタンを選択し、希望するドメインを検索して、チェックアウトプロセスに従ってドメインを購入します。
5. 購入が成功したことを示す確認メールを待ちます。登録プロセスの完了を待つ必要もあります。
6. 最後に、ドメインの移管のロックを無効にします。これ「登録済みドメイン」タブでドメインを選択し、「移管のロック」の隣の「無効化」ハイパーリンクをクリックすることで行えます。

希望のドメインを登録したら、4 つのレコードを作成する必要があります…

1. 左側のツールバーにある「ホストゾーン」タブに移動し、ドメインをクリックします。
2. ドメインの詳細で、「レコードを作成」を選択して、プレースホルダー値を持つ 4 つの A レコードを作成します。心配しないでください、これらは後で更新します:

** a.   レコード名：{空白のまま}**

レコードタイプ：A

値：0.0.0.0 (プレースホルダー)

** b. レコード名：assets**

レコードタイプ：A

値：0.0.0.0 (プレースホルダー)

** c. レコード名：stream**

レコードタイプ：A

値：0.0.0.0 (プレースホルダー)

** d. レコード名：cors**

レコードタイプ：A

値：0.0.0.0 (プレースホルダー)

これが完了したら、デプロイ用にドメインを適切に設定したことになります。このガイドの後のほうで、それらのプレースホルダーレコード値を更新します。

# ステップ 2: AWS の Simple Email Service (SES) で SMTP を設定する

Hubs では、ユーザーのメールアドレスを Spoke シーン、ルーム、アバターなど重要なアカウント情報と関連付ける必要があります。ユーザーにメールを送信するために、 Simple Mail Transfer Protocol（SMTP）を設定する必要があります。

1. AWS コンソールで「Amazon Simple Email Service」に移動します。

2. 左手のツールバーで「SMTP 設定」を選択します。

3. **SMTP エンドポイント URL**をメモしておきます。これは後で使用します。

4.「SMTP 認証情報の作成」ボタンを選択します。

5.（オプション）「ユーザーの詳細を指定」ページで、割り当てられた IAM ユーザー名をカスタマイズすることができます。

6.「ユーザーのアクセス許可ポリシー」に以下のキーが対応する値を持っていることを確認します：

“Effect”: ”Allow”
 “Action”: ”ses:SendRawEmail”
 “Resource”: ”\*”

7.「ユーザーの作成」を選択します。

8.** SMTP ユーザー名**と**SMTP パスワード**をダウンロードまたはコピーします。これらは後ほど Community Edition のデプロイメント仕様を設定する際に使用します。

これが完了したら、メールサービスはデプロイメントのために適切に設定されたことになります。

💡

このクイックスタートガイドは、私の Hub のドメインと管理者のメールアドレスを検証済みのアイデンティティとして、SES がまだサンドボックスモードである状態でテストされました（サンドボックス内では SES は未検証の受信者と送信者との送受信は出来ません）。Hubs Cloud と同様に、あなたの Hubs を本番環境用にするためには、SES の上限を増やすことをリクエストするのをお勧めします。

# ステップ 3：Google Cloud Kubernetes Engine を使用して Kubernetes クラスタを作成する

次に、Community Edition コンテナを保持するための新しい Kubernetes クラスタを作成する必要があります。google-cloud-sdk がインストールされたコマンドラインを使用して、このクラスターを作成できます：

1. google cloud sdk にログインします。

   gcloud auth login

2. クラスタを作成したいプロジェクトで作業していることを確認します。プロジェクトを新しく作成する必要がある場合は、[これらのステップ](https://cloud.google.com/sdk/gcloud/reference/projects/create)に従ってください。

   gcloud config list

3. 正しいプロジェクトで作業**していない**場合は、次のコマンドを実行して正しいプロジェクトに変更します。

   gcloud config set project <YOUR_PROJECT_ID>

4. K8s クラスタを作成します。一般に、クラスタは対象のユーザーベースに最も近いゾーンに割り当てることをお勧めします.ゾーンに関する詳細な情報は[こちら](https://cloud.google.com/compute/docs/regions-zones)で確認できます。

   gcloud container clusters create <YOUR_DESIRED_NAMESPACE> --zone=<YOUR_DESIRED_ZONE>

5. クラスタが構成されるのを待ちます。これには数分かかる場合があります。完了すると、クラスタに関する確認メッセージと関連情報が届きます。

   Created [<https://container.googleapis.com/v1/projects/YOUR_PROJECT_ID/zones/YOUR_DESIRED_ZONE/clusters/YOUR_DESIRED_NAMESPACE>].

これで、私たちの K8s クラスタは、Community Edition 用のデプロイメント仕様の適用が可能になりました！

# ステップ 4：Community Edition をダウンロード、設定、そしてデプロイする

Community Edition を構成するコードは、現在[Hubs Cloud の GitHub リポジトリのこのセクション](https://github.com/mozilla/hubs-cloud/tree/feature/ce/community-edition)にあります。K8s クラスタにデプロイするには、リポジトリをダウンロードし、我々が使用するサービスに関する情報を用いてデプロイメントスクリプトを編集し、設定ファイルをデプロイする必要があります。

1. VSCode のコマンドラインを使用して GitHub リポジトリをクローンします。

   git clone <https://github.com/mozilla/hubs-cloud.git>

2. community-edition ディレクトリに移動します。

   cd community-edition

3. VSCode で`render_hcce.sh`を編集し、以下の**必要な**パラメーターの内容を使用するサービスの情報に置き換えます。また、ローカルのデバイスに保存するべき複数の秘密のパスワードも設定します：

** HUB_DOMAIN** | Route53 からのドメイン。
**ADM_EMAIL** | 作成時に管理者権限を与えたメールアドレス。
**Namespace** | Kubernetes クラスタ内で使用する名前空間。
**DB_PASS** | あなたが選んだ秘密のパスワード。
**SMTP_SERVER** | SES の SMTP エンドポイントの URL。
**SMTP_PORT** | 587
**SMTP_USER** | SES の SMTP ユーザー名。
**SMTP_PASS** | SES の SMTP パスワード。
**NODE_COOKIE** | あなたが選んだ秘密のパスワード。
**GUARDIAN_KEY** | あなたが選んだ秘密のパスワード。
**PHX_KEY** | あなたが選んだ秘密のパスワード。

4.（オプション）VSCode で`render_hcce.sh`を編集し、**SKETCHFAB_API_KEY**および**TENOR_API_KEY**をこれらのサービスの認証情報に置き換えます。[Sketchfab](https://sketchfab.com/developers)（3D モデル検索用）や[Tenor](https://tenor.com/gifapi/documentation)（アニメーション GIF 検索用）を設定したくない場合は、これらの値をそのままにしておいてよいです。

5. デプロイメントスクリプトの設定が完了したら、以下のコマンドを実行してデプロイメント仕様を作成し、クラスタに適用します。

   bash render_hcce.sh && kubectl apply -f hcce.yaml

6. デプロイの完了を待ちます。これには数分かかる場合があります。

7. 次のコマンドでデプロイが正常に行われたかを確認します。戻り値で 11 個のポッドがリストされているはずです。

   kubectl get deployment -n NAMESPACE_WITHIN_CLUSTER

8. より詳しく調べたい場合は、各ポッドの詳細を調べて、意図した値が存在することを確認できます。特に、Reticulum ポッドの情報を確認することをお勧めします。

   kubectl describe deployment POD_NAME -n NAMESPACE_WITHIN_CLUSTER

💡

Community Edition のコードベースのスクリプトは、デバイスやオペレーティングシステムに応じて調整する必要があるかもしれません。例えば、`render_hcce.sh`の 58 行目と 59 行目は、M1 macOS 13.1 上で実行するために、`base64 <secret> -w 0`から`base64 -i <secret>`に修正しました。

# ステップ 5: サービスの公開

Community Edition インスタンスにアクセスする前に、ドメインを自動的に割り当てられた外部 IP アドレスに紐付ける必要があります。

1. インスタンスの外部 IP アドレスを取得します。

   kubectl -n NAMESPACE_WITHIN_CLUSTER get svc lb

2. AWS Route53 の”Hosted Zones”タブに戻り、ドメインを選択します。

3. 以前に作成した 4 つの A レコードのプレースホルダー値をインスタンスの外部 IP アドレスで置き換えます。これらは以下の通りです:

** <HUB_DOMAIN>**
**assets.<HUB_DOMAIN>**
**stream.<HUB_DOMAIN>**
**cors.<HUB_DOMAIN>**

4. すべてのレコードを保存し、変更が反映されるのを数分待ちます。

# ステップ 6: Lens を使用してインスタンスを検証および管理する

IP をドメインに公開したら、設定したドメインで Community Edition インスタンスの使用を開始できるようになります。

**初めてドメインに接続する...**

1. ドメインに接続を試みます。まだ Hub の証明書を設定していないため、証明書を「自己署名」する必要があります。 証明書のないドメインのページを開こうとすると、Web ブラウザは警告を表示し、それでもページを閲覧するかどうかのオプションを提示します。Firefox の場合は、「詳細設定」をクリックして「危険性を承知で続行」を選択すれば実現できます。
2. URL を初めて開くするとき、メールアドレスを使用してサインインするように促されます。

**Reticulum ログを確認する...**

1. Lens と呼ばれる無料インターフェースを使用して K8s クラスターのバックエンドを確認すると便利です。設定プロセス中に、Lens は Google Cloud アカウントに関連付けられたすべてのアクセス可能なクラスタを自動的に検出するはずです。次に、左側のツールバーを使用して個々のクラスタとそのポッドを確認できます。
2. Reticulum のポッドを選択し、詳細ページの右上隅にあるアイコンをクリックしてログを開きます。ログアイコンは、4 つの水平線で示され、4 番目の線が他の線より短いです。
3. Reticulum のログを選択すると、インスタンスのバックエンドで発生しているプロセスを閲覧できるはずです。

**SMTP が正しく動作していることを確認する...**

1. Reticulum のログを開いた状態で、Web ブラウザで ADM_EMAIL のメールアドレスを使用してインスタンスにサインインを試みます。
2. 成功した場合、Reticulum はリクエストを登録し、noreply@<HUB_DOMAIN>からメールが届くはずです。 これにより、部屋を作成したり、アセットをアップロードしたり、シーンを Hub にデプロイしたりすることができるようになります！
3. もし失敗した場合、Reticulum はエラーの原因を記録するので、それを使用してトラブルシューティングを行うことができます。

**設定値を確認してください...**

1. Lens に戻り、左側のツールバーにある”Pods”タブを選択し、あなたの Reticulum ポッドを選択します。
2. “Pod Shell”を開き、ssh を使用してあなたの Reticulum ポッドに接続します。このアイコンは”Pod Logs”アイコンの直接左にあるはずです。
3. Pod Shell で、以下のコマンドを実行します：

   cat config.toml

4. これにより、デプロイメントの設定に使用した値が返されます。実行中の値が設定した値と一致することを確認してください。

# 設定値を更新して再デプロイ...

1. 更新された設定値で Community Edition をデプロイするコマンドをいつでも再実行できます。
2. 設定を再デプロイした後、変更が反映されるためには、現在稼働中のポッドを再起動する必要があります。これは、”Pods”タブの Lens インターフェースを使用して、すべてのポッドまたは個々のポッドを単純に削除することで実現できます。Kubernetes のおかげで、Community Edition は自動的に最新の更新を含む新しいポッドを作成しようと試みます。

💡

注意してください。ポッドを終了すると、重要なデータを損なったり削除してしまう結果になることがあります。デプロイメントプロセス中のトラブルシューティングには役立ちますが、本番環境では K8s のポッドを無闇に終了すべきではありません。

# ステップ 7: 証明書の設定

このガイドの最後のステップは、インスタンスを保護し、Web ブラウザーに表示される自動 SSL 警告を取り除くために証明書を設定することです。Community Edition の GitHub README には、証明書を設定するための 2 つのオプションが記載されています：
A. Hubs チームの certbotbot サービスをデプロイしてもよいです。
B. コマンドラインや Lens のようなインターフェースを使用して、手動で証明書を設定することもできます。

このチュートリアルでは、**オプション A**を採用します。

1. VSCode で`cbb.sh`を編集し、以下の必要なパラメーターを選択した設定で置き換えます

** ADM_EMAIL** | `render_hcce.sh`で指定したのと同じメールアドレス
**HUB_DOMAIN** | Route53 からのドメイン。
**Namespace** | K8s クラスタであなたが設定した名前空間。

2. 必要なパラメーターを設定したら、以下のコマンドを実行して、サービスを K8s クラスターに追加します。

   bash [cbb.sh](http://cbb.sh/)

3. 適用後、Lens インターフェースを使用してサービスが追加されたことを確認します。左手のツールバーの”Pods”タブに移動します。`certbotbot-http`が表示され、エラーが見られないことを確認してください。

4. 数分後、Community Edition ドメインに接続を試みます。これにより、Web ブラウザー上で SSL 警告が表示されなくなるはずです。

# 結論

このガイドが Hubs Community Edition を構成する技術についての情報を提供し、ご自身のインスタンスの設定に役立ったことを願っています。このガイドはクイックスタートであり、Community Edition のバージョンを本番環境に対応させるためには、多くのアップグレードを検討すべきである、ということを念のためにお伝えしておきます。

- **スケーラビリティ** | この方法で作成したインスタンスは約 15 人の同接ユーザーをサポートできます。水平および垂直方向のスケーリングのために追加のサービスを追加することで、容量を増やすことができます。
- **AWS SMTP サンドボックス** | この方法で作成されたインスタンスは、Hub のユーザーに送信できるメールに制限があるかもしれません。上限増加をリクエストする手順は Hubs Cloud と同様で、[こちらに文書化](https://hubs.mozilla.com/docs/hubs-cloud-aws-troubleshooting.html#youre-in-the-aws-sandbox-and-people-dont-receive-magic-link-emails)されています。
- **カスタムアプリの Dev Ops** | この方法で作成されたインスタンスは、Hubs コードベースの最新バージョンを自動的に追跡します。多くの開発者が Hubs クライアント、Reticulum、および Spoke の独自バージョンをデプロイしたいと思っていることは存じ上げています。それを行うには、独自のデプロイメントシステムを設定する必要があります。今後数ヶ月間でその手順に関する詳細なドキュメントを公開予定なので、お待ちください。
- **Hubs Cloud データの移行** | 既存の Hubs Cloud のお客様は、既存のデータを Community Edition インスタンスに移行したいと考えるかもしれません。このプロセスを迅速かつ簡単にするため、自動化されたツールとドキュメントを今後数ヶ月にわたってリリースする予定ですので、**ご期待ください**。

コミュニティがこの新技術をどのように使用するのか、そして Community Edition の改善方法について皆さんからのフィードバックを待ち望んでいます。ご意見を共有し、最新情報を入手する最良の方法は、私たちの[Discord サーバーに参加して](https://discord.gg/v8xTFVNA)#community-edition チャンネルを調べて見ることです。

# アップデート：2023 年 12 月

読者の皆様、ただいま、Hubs Cloud の管理パネルで見られたような設定の構成方法、および Hubs チームが使用している手順を用いて Hubs を構成するサービスのカスタムバージョンをデプロイする方法に関する、新しいセクションをこのドキュメントに追加中です。

## Admin Settings の設定

Hubs Community Edition は、管理パネルを含め、サブスクリプション版の Hubs と同じコードの多く使用しています。Community Edition の管理パネルと Hubs Cloud のバージョンの管理パネルの主な違いは、特定の設定を構成するためのフィールドの有無です。例えば、以下のようなものです:

- 開発者が外部 API にアクセスすることを許可するものを含む、追加のコンテンツセキュリティポリシーのルール
- アバター、ルーム、およびシーンのための追加のヘッダー、HTML、およびスクリプト

Community Edition でも、これらの設定は K8s クラスタにチャートをデプロイする際に引き続き構成可能です。これらを構成するには、`config.toml.template`を参照して、チャートの該当部分に希望の値を入力してください：

    [ret."Elixir.RetWeb.Plugs.AddCSP"]
    child_src = ""
    connect_src = "wss://*.stream.<DOMAIN>:4443"
    font_src = ""
    form_action = ""
    frame_src = ""
    img_src = "nearspark.reticulum.io"
    manifest_src = ""
    media_src = ""
    script_src = ""
    style_src = ""
    worker_src = ""

    [ret."Elixir.RetWeb.PageController"]
    skip_cache = false
    extra_avatar_headers = ""
    extra_index_headers = ""
    extra_room_headers = ""
    extra_scene_headers = ""

    extra_avatar_html = ""
    extra_index_html = ""
    extra_room_html = ""
    extra_scene_html = ""

    extra_avatar_script = ""
    extra_index_script = ""
    extra_room_script = ""
    extra_scene_script = ""

例えば、私の Hub が迅速なモデレーションや画像生成のために OpenAI API を呼び出せるようにしたい場合、`script_src`のコードは次のようになります。各 URL はシングルスペースで区切ってください

    script_src = "<https://api.openai.com/v1/moderations> <https://api.openai.com/v1/images/generations>"

## カスタムアプリのデプロイ

デフォルトでは、Community Edition は私たちの公開されている docker レジストリに含まれる Hubs のコードベースの最新リリースを追跡します。しかし、多くの開発者は、Hubs の様々なコードベースの自身のバージョンをデプロイしたいと考えるかもしれません。ここでは、Hubs チームが GitHub Actions を利用してあなた自身の docker レジストリを構築し、このコードを Community Edition インスタンスで使用する方法について手順を追って説明します。

1. まず、[docker hub](https://hub.docker.com/)アカウントを作成し、必要なら、あなたのイメージのためのレジストリを作成します。デフォルトでは、docker hub はあなたのユーザー名でレジストリを作成します。
2. カスタマイズしたい Hubs のコードベースを GitHub でフォークしてください（これを行うためには GitHub アカウントが必要です）。このチュートリアルでは、Hubs クライアントを使用し、カスタマイズを加えるための開始点として master ブランチを使用します。
3. カスタマイズが完了し、デプロイ準備ができたら、`.github/workflows/` に移動し、Hubs チームメンバーの Brandon Patterson が作成した[このコード](https://github.com/mikemorran/hubs/blob/master/.github/workflows/ce-build.yml)を入力した`ce-build.yml`というファイルを追加します。完了したら、これらの変更がチェックインされ、フォークした master ブランチにマージされていることを確認してください。
4. GitHub リポジトリの Actions セクションに移動してください。`ce-build.yml`を追加しコミットした後、”ce”というアクションが一覧に表示されるはずです。
5. あなたのフォークの settings タブに移動し、”Secrets and Variables”そして”actions”を選択します。"DOCKER_HUB_PWD"という名前の新しいリポジトリシークレットを作成します。シークレットの値には、docker hub のパスワードを入力するか、docker hub でアクセストークンを作成し、そのシークレットのパスワードを使用します。
6. シークレットを保存したら、”Actions”タブに戻り、”ce”を選択し、”Run Workflow”を選びます。ポップアップで、master ブランチを選択し、”CodePath”は空欄のままとし、”DOCKER_HUB_USR”は docker hub のユーザー名を入力し、dockerfile が`RetPageOriginDockerfile`であることを確認し、”registry”に docker hub のレジストリ名を入力してください。
7. ビルドが成功するのを待ちます。docker hub で成功したデプロイメントを確認できます。
8. 最後に、カスタマイズされたバージョンの Hubs クライアントを使用するようにコミュニティ版のデプロイメントを更新する必要があります。`hcce.yaml`の中で、`mozillareality/hubs:stable-latest`を指す代わりに、デプロイされたコードを含むあなたの docker イメージを指定してください。
