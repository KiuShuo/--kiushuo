# 关于‘优化UITableViewCell高度计算的那些事’的讨论

[优化UITableViewCell高度计算的那些事](http://blog.sunnyxx.com/2015/05/17/cell-height-calculation/)

结论：==预估高度用起来还是有些问题，所以还是需要要用`UITableView+FDTemplateLayoutCell`来计算高度。==

###### 下面的讨论时基于`UITableView+FDTemplateLayoutCell`提供的Demo做的，可以直接到[github](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell)上下载测试。

### “滚动条跳动”  “iOS8高度计算抽风”

当设置预估高度 tableView.estimatedRowHeight = 10.0时

| 4.0寸 |  数据个数 n | 初始cellForRow执行次数 | 初始heightForRow执行次数 |总高度|
|:---: |:---:|:---:| :---:|:---:|
|  开启 | n <= 46 / n > 46 | n / 46 | n / 46 |9852.000000 = 21.42 * 460 (568 - 64 -44 = 460 = 10 * 46)|
| 未开启| n | 当前屏幕需要显示的cell数 nc | n + nc||

| 4.7寸 |  数据个数 n | 初始cellForRow执行次数 | 初始heightForRow执行次数 |总高度
|:---: |:---:|:---:| :---:|:---:|
|  开启 | n <= 56 / n > 56 | n / 56 | n / 56 |11518.500000 ≈ 20.1 * 559 (667 - 64 - 44 = 559 ≈ 56 * 10) |
| 未开启| n | 当前屏幕需要显示的cell数 nc | n + nc| |

| 5.5寸 |  数据个数 n | 初始cellForRow执行次数 | 初始heightForRow执行次数 |总高度|
|:---: |:---:|:---:| :---:|:---:|
|  开启 | n <= 63 / n > 63 | n / 63 | n / 63 |13109.333333 ≈ 20.89 * 628 (736 - 64 - 44 = 628 ≈ 63 * 10) |
| 未开启| n | 当前屏幕需要显示的cell数 nc | n + nc||

* ==初始状态heightForRow的执行次数 = tableView.height(有效高度) ／ tableView.estimatedRowHeight==  
* 初始状态heightForRow的执行次数 -> cell总高度 = 高度计算系数n * tableView.height(有效高度); 其中高度计算系数n约等于21(是一个固定的值，具体多少并不重要).  

#### 为什么会有初始状态heightForRow的执行次数 = tableView.height(有效高度) ／ tableView.estimatedRowHeight？

实际上，当设置过预估高度后，初始状态不会再将所有的cell的高度都计算出来（不会先执行n次heightForRow:），而是去执行cellForRow:，而cellForRow:的执行次数时当前tableView可以显示出的可见的cell数，而这个数量与tableView.height和cellHeight有关，当我们设置过预估高度后，系统认为每个cell的高度值是相同的，且都等于tableView.estimatedRowHeight，所以这是后系统计算出的可见cell数量为m = tableView.height(有效高度) ／ tableView.estimatedRowHeight，因此cellForRow会这行m次，而每执行一次cellForRow必定会执行一次heightForRow，所以初始状态下heightForRow的执行次数为m即 初始状态heightForRow的执行次数 = tableView.height(有效高度) ／ tableView.estimatedRowHeight。

#### 为避免滑动界面时出现滑动指示器跳动的情况，预估高度设为多少比较合适？

一般情况下，tableView.height(有效高度)是固定的，所以随着预估高度的值的增大，初始状态heightForRow的执行次数会减少，当初始状态heightForRow的执行次数 < tableView上初始状态下要显示的cell数量的时候，滑动过程中会出现滑动指示器跳动的情况，且出现在初始状态heightForRow的执行次数对应的行之后。  

当一个列表显示的数据过多时，我们一般会做分页加载处理，假设一页加载m条数据，根据4寸屏幕计算，tableView.estimatedRowHeight = (568 - 64 - 44) / m, 当m = 20时，tableView.estimatedRowHeight = 23, 即当每页显示20条数据、 tableView.estimatedRowHeight <= 23时，在4寸屏幕上不会出现滑动指示器跳动的情况。同一界面，4.7寸和5.5寸的tableView.height(有效高度) > 4.0寸的tableView.height(有效高度), 所以只要在4.0寸上不会出现滑动指示器跳动，在更大的屏幕上也一定不会出现。

总结：  
1. 当设置==预估高度tableView.estimatedRowHeight <= tableView.height(需最小适配屏幕尺寸上的有效高度) ／ 要显示的cell数量== 时，就不会出现滑动指示器跳动的情况。  
2. iOS8之后，高度计算次数与系统版本无关，只与tableView.height(有效高度)和tableView.estimatedRowHeight有关。

#### 当列表分页加载时，会不会出现滑动指示器跳动？

当列表分页加载时，即使是按照上面的方法计算出理想的预估高度值，但是当加载出下一个页面时，新多出来的数据的heightForRow方法并不会都执行，仅仅执行了会显示出来的那1-3个cell对应的高度计算方法，所以此时如果继续向下滑动，就==会出现滑动指示器跳动==的情况。


### `-systemLayoutSizeFittingSize:`

作者在文中提到了`AutoLayout`后系统提供的计算cell高的函数`-systemLayoutSizeFittingSize:`相较于手算高度的一些缺点，但是实际上，为了计算高度的通用性，FDTempLayout中计算高度默认使用该方法。  

当然，如果不想使用该方法，可以在cell中实现`sizeThatFits:`方法来手动计算cell高度，同时配置该cell的`fd_enforceFrameLayout`为`false`。

### `preferredMaxLayoutWidth`

1.6版本后不需要对换行的label设置该属性，1.6以及之前的版本，如果不设置在iOS10.2之后label高度计算会不准确。当`UITableView+FDTemplateLayoutCell`1.7版本出来后，就可以删掉代码中的`preferredMaxLayoutWidth`.


### FDTempLayout中除了高度计算，另外一个主要功能/特色就是高度缓存  

当使用预估高度的时候，系统到底有没有对cell的高度进行缓存处理？  

FDTempLayout中使用系统的`-systemLayoutSizeFittingSize:`函数计算高度，而后通过`indexPath`或者`cellIdentifier`对高度进行缓存处理，这样可以减少高度计算次数，提高滑动性能。   

使用预估高度处理cell高度后系统到底有没有进行缓存处理暂不得而知，但根据上面的讨论，使用预估高度是有局限性的，所以还是要使用FDTempLayout来进行高度计算，故预估出的高度有没有缓存暂时没有讨论的意义。



