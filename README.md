# release_test

GoのCLIツールをGitHub ActionsでReleaseするテスト。

- tool_a
  - `tool_a/v[0-9]+.[0-9]+.[0-9]+'`形式のtagをpushしたら発動する。
  - ググるとよく出るパターン。
  - [actions/create-release](https://github.com/actions/create-release) と [actions/upload-release-asset](https://github.com/actions/upload-release-asset) の組み合わせ。
  - どちらも更新がなくarchivedになっている。
- tool_b
  - `tool_b/v[0-9]+.[0-9]+.[0-9]+'`形式のtagをpushしたら発動する。
  - create-release と upload-release-asset からリンクされている[softprops/action-gh-release](https://github.com/softprops/action-gh-release) を使ったパターン。
- tool_c
  - https://github.com/mattn/goreman/blob/master/.github/workflows/release.yml を参考にしたパターン
  - [actions/create-release](https://github.com/actions/create-release) と [x-motemen/gobump](https://github.com/x-motemen/gobump) と [Songmu/goxz](https://github.com/Songmu/goxz) と [tcnksm/ghr](https://github.com/tcnksm/ghr) を使用している。
  - ~~gobumpでもtagをpushしているせいか、Releaseが2つにわかれてしまう。~~
  - ~~gobump用に、main.goにconst versionを入れる必要がある。~~
  - `make bump`でいい感じにできる。
- tool_d
  - tool_cでgobumpを使わないパターン。
  - →tool_cの使い方が悪かっただけなのでなし。
