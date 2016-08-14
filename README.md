# AbsoluteTime

在做某一个需求时需要获取在app内的某个时间段，这个时间段满足：

1.不受app是否在前台影响

2.不受用户更改本地时间影响

网上搜了一些获取时间段的方法，较为常见的有四种方式：

1. CACurrentMediaTime()

2.[[NSDate date] timeIntervalSince1970]

3.[[NSProcessInfo processInfo] systemUptime]

4.系统 C api实现

本代码做了一个简单的测试Demo，用来说明：C的api实现是准确满足条件的。
