# JJLISO8601DateFormatter Benchmark

性能对比测试工程，用于对比原始 Objective-C 版本和 Swift 版本的 JJLISO8601DateFormatter。

## 测试结果摘要 (2026-01-08)

| 测试项目 | OC 版本 | Swift 版本 | 对比 |
|---------|--------|-----------|-----|
| **构造性能** | 16.07x faster | 14.49x faster | OC 略快 |
| **字符串转日期** | 22-26x faster | 23-26x faster | 相近 |
| **日期转字符串** | 6-7x faster | 4.6-5.3x faster | OC 较快 |

> 注：所有加速倍数都是相对于 Apple 的 `ISO8601DateFormatter`

## 项目结构

```
JJLISO8601DateFormatterBenchmark/
├── OCVersionBenchmark/          # OC 版本基准测试
│   ├── Package.swift            # 引用 michaeleisel/JJLISO8601DateFormatter
│   └── Sources/
│       └── main.swift           # OC 版本测试代码
├── SwiftVersionBenchmark/       # Swift 版本基准测试
│   ├── Package.swift            # 引用 Asura19/JJLISO8601DateFormatter
│   └── Sources/
│       └── main.swift           # Swift 版本测试代码
├── Shared/                      # 共享配置
│   └── BenchmarkConfig.swift
├── run_benchmark.sh             # 一键运行脚本
├── compare_versions.sh          # 版本对比脚本
└── README.md
```

## 依赖

- **OC 版本**: https://github.com/michaeleisel/JJLISO8601DateFormatter (v0.1.4+)
- **Swift 版本**: https://github.com/Asura19/JJLISO8601DateFormatter (master 分支)

## 运行方式

### 方式一：版本对比脚本（推荐）

```bash
cd /Users/phoenix/Downloads/JJLISO8601DateFormatterBenchmark
./compare_versions.sh
```

这个脚本会：
1. 构建两个版本
2. 依次运行两个基准测试
3. 将结果保存到文件

### 方式二：分别运行

**运行 OC 版本基准测试:**

```bash
cd /Users/phoenix/Downloads/JJLISO8601DateFormatterBenchmark/OCVersionBenchmark
swift build -c release
swift run -c release
```

**运行 Swift 版本基准测试:**

```bash
cd /Users/phoenix/Downloads/JJLISO8601DateFormatterBenchmark/SwiftVersionBenchmark
swift build -c release
swift run -c release
```

## 测试内容

基于原始测试代码，测试以下三个维度：

### 1. 构造性能 (Construction)
- 测试 10,000 次对象创建的耗时

### 2. 字符串转日期 (String to Date)
- 测试 100,000 次转换
- 分别测试最近 30 天的日期和从 1970 到现在的日期
- 测试三个时区：BRT (巴西)、America/Indiana/Indianapolis、GMT

### 3. 日期转字符串 (Date to String)
- 测试 1,000,000 次转换
- 分别测试最近 30 天的日期和从 1970 到现在的日期
- 测试三个时区：BRT (巴西)、America/Indiana/Indianapolis、GMT

## 格式选项

使用完整的 ISO 8601 互联网日期时间格式：

```swift
let fullOptions: ISO8601DateFormatter.Options = [
    .withInternetDateTime,
    .withColonSeparatorInTimeZone,
    .withFractionalSeconds
]
```

## 输出示例

```
======================================================================
 🚀 JJLISO8601DateFormatter Benchmark - Swift Version (Asura19)
======================================================================
Repository: https://github.com/Asura19/JJLISO8601DateFormatter
Date: 2024-01-08 12:00:00 +0000

----- Construction Performance -----
  JJL (Swift)              : 0.001234 seconds
  Apple ISO8601            : 0.012345 seconds
  📈 Speedup: 10.01x faster

----- String to Date Performance -----

  TimeZone: America/Sao_Paulo
    Recent dates (±15 days):
      JJL (Swift)            : 0.123456 seconds
      Apple ISO8601          : 1.234567 seconds
      📈 Speedup: 10.00x faster
...
```

## 注意事项

1. 建议在 Release 模式下运行以获得准确的性能数据
2. 关闭其他应用程序以减少干扰
3. 多次运行取平均值以获得更可靠的结果

## 参考

- 原始测试代码来自 JJLISO8601DateFormatter 项目的 Example 工程
- [JJLISO8601DateFormatter GitHub](https://github.com/michaeleisel/JJLISO8601DateFormatter)
