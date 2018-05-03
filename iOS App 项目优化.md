### iOS App 项目优化


#### 1 启动耗时优化  
启动时间 = main之前的启动时间 + main之后的启动时间；  
标准： WWDC 2016上Apple建议一个App完整的启动时间应该保证400ms之内,而若超过20s后还未完全启动App,那么App进程就会被系统杀死. 提到main之前的启动时间400ms；    

我们目前的app启动时间：main之前是  900ms-1.3s之间；   main函数之后 `application:DidFinishLaunch:`执行完成所需时间：   ；

Xcode 测量 mian之前的启动时间：  
`DYLD_PRINT_STATISTICS、 DYLD_PRINT_STATISTICS_DETAILS`使用dyld打印统计数据；  
线上度量 main之前的启动时间：  

[官方：优化App启动时间](https://developer.apple.com/videos/play/wwdc2016/406/)  
[如何精确度量 iOS App 的启动时间](https://www.jianshu.com/p/c14987eee107)  
[iOS App 启动性能优化](https://mp.weixin.qq.com/s/Kf3EbDIUuf0aWVT-UCEmbA)  
[APP启动优化的一次实践](https://icetime17.github.io/2018/01/01/2018-01/APP%E5%90%AF%E5%8A%A8%E4%BC%98%E5%8C%96%E7%9A%84%E4%B8%80%E6%AC%A1%E5%AE%9E%E8%B7%B5/)

#### 2 编译耗时优化
编译时间的直接影响开发效率，之前的时候项目的编译时长达到过5分钟左右;   
希望能控制在3分钟之内，尽量时间越短越好。  

#### 5 打包耗时优化  
仅从目前的现状 也就是现在的万家2B项目的前提下说，目前jenkins打包的包含的几个步骤，以及大概的耗时；  
git pull 更新代码 1s <- 检查更新描述文件 1s -> pod install 1s-19s=18s -> xcodebuild clean archive 19s-725s=706s 11min -> xcodebuild exportArchive 725s-755s=30s -> 上传蒲公英 755s-838s=83s   

[如何将 iOS 工程打包速度提升十倍以上](https://bestswifter.com/improve_compile_speed/)   

#### 3 ipa大小优化

appStore 65.3MB,  ipa 130.6MB, 蒲公英 52MB, 可执行文件大小 38M

appStore中看到的安装包大小 = 可执行文件大小 + 

```
__TEXT	__DATA	__OBJC	others	dec	hex
20348928	2359296	0	1015808	23724032	16a0000	wanjia2B.app/wanjia2B (for architecture armv7)
18939904	4374528	0	4295917568	4319232000	101724000	wanjia2B.app/wanjia2B (for architecture arm64)
```

App 的完整未压缩大小不得超过 4GB
可执行文件大小的限制和系统有关，目前兼容到iOS8，上限是60MB

苹果官方对可执行文件的大小有一定的限制，目前来说肯定是满足的；  
[查看构建版本和文件大小](https://help.apple.com/itunes-connect/developer/#/dev3b56ce97c)  
[最大构建版本文件大小](https://help.apple.com/itunes-connect/developer/#/dev611e0a21f)  
[App 瘦身概览（iOS、tvOS、watchOS）](https://help.apple.com/xcode/mac/current/#/devbbdc5ce4f)  
[《iOS安装包瘦身指南》](http://www.zoomfeng.com/blog/ipa-size-thin.html)    
[iOS坑：IPA可执行文件大小限制](https://www.jianshu.com/p/0e8160cdbf3f) 


#### 7 app内存使用大小优化      

[iOS单个app最大内存占用限制](https://blog.csdn.net/fishmai/article/details/74840514)   

#### 8 cpu占用率优化
  
#### 9 应用流畅性优化     
有几个界面确实存在肉眼可见的卡顿的现象，比方说 我的执业地点、热点医讯界面，具体的掉帧或者说卡顿情况需要进一步的使用Xcode自带的工具进行检测，并通过对代码的优化来改进。    

Permisson to debug com.pingan.wanjiaB was denied. The app must be signed with a development identify

热点医讯界面：  
如果不进行赋值操作，则帧率在53-60之间

[离屏渲染优化详解：实例示范+性能测试](https://www.jianshu.com/p/ca51c9d3575b)  
[UIView的alpha、hidden和opaque属性之间的关系和区别](https://blog.csdn.net/wzzvictory/article/details/10076323https://blog.csdn.net/wzzvictory/article/details/10076323)  
[Instruments性能优化-Core Animation](https://www.jianshu.com/p/439e158b44de)  
  
  
4 代码优化 需要具化  
10 代码可读性优化  
11 代码复用便捷性优化  
6 重复逻辑、重复功能优化   

代码的优化其实可以影响到其他几项，好代码的标准到底是什么？ 
