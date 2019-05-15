# m7-code-maker-host
[摸索中] Xcode插件，生成常用代码


------
# 命令列表

### Singleton
- 在类的.m文件中生成单例方法
- 不需要选中文本
- 如果有多个类，只为最上面的类生成

### Getter
- 在类的.m中选中property所在的行（可选择多个property）
- 在.m底部生成getter方法
- Inspired by [LazyPlugin](https://github.com/nangege/LazyPlugin)

------
# 使用
- 打开项目，Product-Archive打包
- Xcode中，在包上右键Show in Finder
- 在包右键显示包内容，Products-Applications
- 将m7-code-maker-host复制到系统的应用程序中
- 双击启动一次m7-code-maker-host
- OK