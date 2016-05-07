# LoadingHUD

网络加载遮罩层，当加载失败时可以重新加载数据 

---
实现效果

---
**关于LoadingHUD**

- 可以更改正在加载时默认的动画效果
- 可以更改加载失败时默认提示的图片样式

**关于动画效果，使用了一些小技巧让视图自己去管理`NSTimer`的生命周期。当视图销毁时`NSTimer`对象也会随之`invaild`。而不会发生视图与`timer`之间相互引用的情况，当自定义动画效果时可以参考`LSYActivityIndicator`文件中关于`NSTimer`的使用**

---
##使用
`LoadingHUD`是一个视图控制器，因为这样能更好的管理视图周期。使用时只需要把`LoadingHUD`添加到要显示遮罩层的视图控制器中。为了方便使用提供了`类方法`与`实例方法`

- 显示遮罩
```objective-c
-(void)showHUDText:(NSString *)text inViewController:(UIViewController *)vc;
```

- 显示加载失败
实例方法
```objective-c
-(void)showFailHUDText:(NSString *)text inViewController:(UIViewController *)vc reload:(reload)reload;
```
类方法
```objective-c
+(void)failHUDText:(NSString *)text inViewController:(UIViewController *)vc reload:(reload)reload;
```

- 隐藏遮罩
实例方法
```objective-c
-(void)hiddenHUDViewController:(UIViewController *)vc;
```
类方法
```objective-c
+(void)hiddenAllHUD:(UIViewController *)vc;
```
