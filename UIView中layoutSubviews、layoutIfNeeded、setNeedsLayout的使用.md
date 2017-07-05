# UIView中layoutSubviews、layoutIfNeeded、setNeedsLayout的使用


### `layoutSubviews`

根据[官方文档](https://developer.apple.com/documentation/uikit/uiview/1622482-layoutsubviews) 的介绍可以看出，开发者不应该直接调用`layoutSubviews`方法，如果想强制更新布局，要调用`setNeedsLayout`方法，但该方法不会立即 重绘视图(drawing)。如果想立即更新 视图布局(layout)，可调用 `layoutIfNeeded` 方法。  

当开发者认为系统默认的布局和约束不能满足其想要的效果时，可以在子类中重写`layoutSubviews`方法，从而实现精准布局。（如：更改系统cell上自带的子视图的frame）。反过来说，如果使用系统默认的布局和约束可以满足布局需求，则无需重写该方法。  

即然开发者不能直接调用`layoutSubviews`方法，只能由系统调用，那么具体的系统调用时机是什么？  

1. 调用 `addSubview` 方法时会执行该方法。
2. 设置并改变子视图的frame属性时会触发该方法。（ 设置并改变视图的frame属性时会触发父视图的`layoutSubviews`方法。）  
3. 初始化不会触发`layoutSubviews`，但是如果设置了不为CGRectZero的frame的时候就会触发。
4. 滑动 `UIScrollView`或继承于`UIScrollView`的控件 时会触发该方法。
5. 旋转屏幕时，会触发父视图的`layoutSubviews`方法。


### `layoutIfNeeded`

根据[官方文档](https://developer.apple.com/documentation/uikit/uiview/1622507-layoutifneeded)的介绍可以看出，该方法的作用是立即布局子视图。  

使用这个方法可以在系统绘制视图之前强制（重新）布局子视图。这个方法将从当前视图开始布局当前视图树之下的所有子视图。

### `setNeedsLayout`

根据[官方文档](https://developer.apple.com/documentation/uikit/uiview/1622601-setneedslayout)介绍可以看出，该方法的作用是记录布局请求，并立即返回。该方法不会立即更新布局，而是等到下一个更新周期，所以你可以在当前的无效周期内添加多个多个视图的布局，等到下一个周期同一更新。这么做通常可以获得更好的性能。

参考资料：  
https://developer.apple.com/documentation/uikit/uiview#//apple_ref/occ/cl/UIView  
https://developer.apple.com/documentation/uikit/uiview/1622482-layoutsubviews
https://developer.apple.com/documentation/uikit/uiview/1622507-layoutifneeded
https://developer.apple.com/documentation/uikit/uiview/1622601-setneedslayout

[谈谈UIView的几个layout方法-layoutSubviews、layoutIfNeeded、setNeedsLayout...](http://www.jianshu.com/p/eb2c4bb4e3f1)  
[UIView的layoutSubviews、layoutIfNeeded、setNeedsLayout区别和联系](http://gurglessh.github.io/2016/04/16/UIView%E7%9A%84layoutSubviews%E3%80%81layoutIfNeeded%E3%80%81setNeedsLayout%E5%8C%BA%E5%88%AB%E5%92%8C%E8%81%94%E7%B3%BB/)  
[【iOS 开发】从 setNeedsLayout 说起](http://www.jianshu.com/p/e1eca032be15)



