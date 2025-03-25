<a name="readme-top"></a>

[English](./README.md) | 简体中文


[![贡献者][contributors-shield]][contributors-url]
[![分支数][forks-shield]][forks-url]
[![星标数][stars-shield]][stars-url]
[![问题数][issues-shield]][issues-url]
[![Apache 许可证][license-shield]][license-url]


<br />
<div align="center">
  <a href="https://github.com/maiqingqiang/ChatMLX">
    <img src="ChatMLX/Assets.xcassets/AppIcon.appiconset/1024.png" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">ChatMLX</h3>

  <p align="center">
    ChatMLX 是一款现代化的开源高性能聊天应用，基于大型语言模型，依托于强大的<a href="https://github.com/ml-explore/mlx-swift">MLX</a>和 Apple silicon。它支持多种模型，为用户提供丰富多样的对话选项。该应用在本地运行 LLM，以确保用户隐私和安全。
    <br />
    <br />
    <a href="https://github.com/maiqingqiang/ChatMLX/issues">报告错误</a>
    ·
    <a href="https://github.com/maiqingqiang/ChatMLX/issues">请求功能</a>
    ·
    <a href="https://github.com/maiqingqiang/ChatMLX/releases">下载</a>
  </p>
</div>

## 特性 🚀

- **多语言**：支持应用商店中40种主流语言，包括英语、简体中文、繁体中文、日语和韩语。
- **多个模型**：提供多个模型，包括 Llama、OpenELM、Phi、Qwen、Starcoder 和 Cohere。
- **高性能**：基于 MLX 和 Apple silicon 的强大性能。
- **隐私与安全**：在本地运行 LLM，以确保用户隐私和安全。
- **开源**：开源项目，欢迎贡献。

> [!NOTE]
>
> 与 macOS 14.0及更高版本兼容。

![iShot_2024-08-31_23.55.23.png](images/iShot_2024-08-31_23.55.23.png)

![iShot_2024-08-31_23.55.39.png](images/iShot_2024-08-31_23.55.39.png)

## FAQ

### 1. 在 macOS 安装后，打开时显示“文件损坏”或没有响应

由于 ChatMLX 未经过签名，因此被 macOS 安全检查阻止。

如果在安装后遇到“文件损坏”的错误，请按照以下步骤操作：

```bash
xattr -cr /Applications/ChatMLX.app
```

之后，您应该能够正常打 ChatMLX。

如果出现以下信息：

```sh
option -r not recognized

usage: xattr [-slz] file [file ...]
       xattr -p [-slz] attr_name file [file ...]
       xattr -w [-sz] attr_name attr_value file [file ...]
       xattr -d [-s] attr_name file [file ...]
       xattr -c [-s] file [file ...]

The first form lists the names of all xattrs on the given file(s).
The second form (-p) prints the value of the xattr attr_name.
The third form (-w) sets the value of the xattr attr_name to attr_value.
The fourth form (-d) deletes the xattr attr_name.
The fifth form (-c) deletes (clears) all xattrs.

options:
  -h: print this help
  -s: act on symbolic links themselves rather than their targets
  -l: print long format (attr_name: attr_value)
  -z: compress or decompress (if compressed) attribute value in zip format
```

那就执行下面这个命令：

```bash
xattr -c /Applications/ChatMLX.app/*
```

如果以上命令仍然无效，可以尝试以下命令：

```bash
sudo xattr -d com.apple.quarantine /Applications/ChatMLX.app/
```

## Star 历史 🌟

[![星标历史图表](https://api.star-history.com/svg?repos=maiqingqiang/ChatMLX&type=Date)](https://star-history.com/#maiqingqiang/ChatMLX&Date)

[contributors-shield]: https://img.shields.io/github/contributors/maiqingqiang/ChatMLX.svg?style=for-the-badge
[contributors-url]: https://github.com/maiqingqiang/ChatMLX/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/maiqingqiang/ChatMLX.svg?style=for-the-badge
[forks-url]: https://github.com/maiqingqiang/ChatMLX/network/members
[stars-shield]: https://img.shields.io/github/stars/maiqingqiang/ChatMLX.svg?style=for-the-badge
[stars-url]: https://github.com/maiqingqiang/ChatMLX/stargazers
[issues-shield]: https://img.shields.io/github/issues/maiqingqiang/ChatMLX.svg?style=for-the-badge
[issues-url]: https://github.com/maiqingqiang/ChatMLX/issues
[license-shield]: https://img.shields.io/github/license/maiqingqiang/ChatMLX.svg?style=for-the-badge
[license-url]: https://github.com/maiqingqiang/ChatMLX/blob/main/LICENSE

<p align ="right">( < a href="#readme-top ">返回顶部< / a > )< p >