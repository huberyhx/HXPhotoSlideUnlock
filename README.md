最近公司项目中用到解锁码功能,赶巧今天又加班，就用Quartz2D尝试模仿网页的滑动图片解锁做了个Demo
[这是Demo地址](https://github.com/huberyhx/HXPhotoSlideUnlock.git)
效果图:
![效果图](http://upload-images.jianshu.io/upload_images/2954364-6cc9d79589adc678.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![gif图](http://upload-images.jianshu.io/upload_images/2954364-885e99510defc18e.gif?imageMogr2/auto-orient/strip)


- View用法:
1:引入HXPhotoSlideUnlock
2:创建View并且给予图片
```objectivec
    HXPhotoSlideUnlock *unlockView = [[HXPhotoSlideUnlock alloc]initWithFrame:CGRectMake(66, 180, 220, 55)];
    self.imageArray = @[@"image1",@"image2",@"image3",@"image4",@"image5"];
    unlockView.imageArray = self.imageArray;
    [self.view addSubview:unlockView];
```
     view中包括拖动框和拖动按钮
     拖动框的宽度和传入的图片宽度一样
     所以创建的时候 view的宽度尽量不要小于图片宽度

- 实现简介:
![组件图](http://upload-images.jianshu.io/upload_images/2954364-c7bfe850e72e46dc.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
HXPhotoSlideUnlock文件中有两个类:HXPhotoSlideUnlock和HXRespondButton
HXPhotoSlideUnlock就是图中的拖动框
大图是拖动框的子View
HXRespondButton是图中的拖动按钮
小图是拖动按钮的子View(因为小图要跟着拖动按钮移动嘛)
 -  创建拖动按钮并且监听两种点击状态:
```objectivec
-(HXRespondButton *)respondBtn{
    if (!_respondBtn) {
        _respondBtn = [HXRespondButton buttonWithType:UIButtonTypeCustom];
        [_respondBtn setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
        //手指按下按钮时,显示大图 小图
        [_respondBtn addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchDown];
        //手指离开按钮时 判断是否验证成功
        [_respondBtn addTarget:self action:@selector(hiddenImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _respondBtn;
}
```
 - 显示图片的时候,在图片数组中随机取出一张图,并截取出大图和小图
```objectivec
//显示大小图片
-(void)showImage{
    [self.successImageView removeFromSuperview];
    self.imageView.hidden = NO;
    self.respondBtn.isHiddenClipImage = NO;
    //随机获取图片(工具方法)
    UIImage *image = [self getImage];
    CGSize size = image.size;
    //随机生成裁剪位置
    NSUInteger clipX = [self getRandomNumber:(BtnWidth) to:(size.width - BtnWidth)];
    NSUInteger clipY = [self getRandomNumber:0 to:(size.height - ClipWH)];
    clipRect = CGRectMake(clipX, clipY, ClipWH, ClipWH);
    [self setUpImageViewWithImage:image Rect:clipRect];
    [self.respondBtn setClipImage:[self getCilpImageWithImage:image Rect:clipRect]];
    CGRect recc  = CGRectMake(21, 0 - (size.height + 6 - clipY), ClipWH, ClipWH);
    //告诉拖动按钮 我的裁剪位置
    self.respondBtn.clipImageRect = recc;
}
//截大图
-(void)setUpImageViewWithImage:(UIImage *)image Rect:(CGRect)rect{
    CGSize size = image.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [image drawAtPoint:CGPointZero];
    CGContextClearRect(ctx, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = newImage;
}
//截小图
-(UIImage *)getCilpImageWithImage:(UIImage *)image  Rect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, imageRef);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    return newImage;
}
```
 - 手指离开按钮时,判断是否验证成功
```objectivec
-(void)hiddenImage{
    CGRect frame = self.respondBtn.frame;
    CGFloat moveX = frame.origin.x + (BtnWidth - ClipWH)*0.5;
   //拖动位置和裁剪位置差距小于2 是成功
    if (fabs(clipRect.origin.x - moveX) < 2) {//验证成功
        self.imageView.hidden = NO;
        self.respondBtn.isHiddenClipImage = NO;
        [self.rimView addSubview:self.successImageView];
        self.respondBtn.userInteractionEnabled = NO;
        self.result = YES;
        //验证成功后闪亮一下
        [self.imageView.layer addSublayer:self.gradientLayer];
   }else{//验证失败
        self.result = NO;
        self.respondBtn.userInteractionEnabled = YES;
        self.imageView.hidden = YES;
        self.respondBtn.isHiddenClipImage = YES;
        [UIView beginAnimations:@"animationID" context:nil];
        [UIView setAnimationDuration:0.26f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.respondBtn cache:YES];
        [self.respondBtn setFrame:CGRectMake(0, 0, BtnWidth, BtnHeight)];
        [UIView commitAnimations];
       }
}
```
 - 验证成功后,播放闪亮动画
```objectivec
-(CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer =[CAGradientLayer layer];
        _gradientLayer.frame = self.imageView.bounds;
        _gradientLayer.startPoint = CGPointMake(1, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
        _gradientLayer.colors =   @[(__bridge id)[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0].CGColor,
                                    (__bridge id)[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6].CGColor,
                                    (__bridge id)[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0].CGColor
                                   ];
        _gradientLayer.locations = @[@0.25,@0.5,@0.75];
        /**
         * 为渐变View添加动画
         */
        [_gradientLayer addAnimation:self.anima forKey:nil];
    }
    return _gradientLayer;
}
-(CABasicAnimation *)anima{
    if (!_anima) {
        _anima = [CABasicAnimation animationWithKeyPath:@"locations"];
        _anima.delegate = self;
        _anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _anima.fromValue = @[@0.0,@0.0,@0.25];
        _anima.toValue = @[@0.75,@1.0,@1.0];
        _anima.duration = 0.5;
        _anima.repeatCount = 1;
        _anima.removedOnCompletion = NO;
        _anima.fillMode = kCAFillModeForwards;
    }
    return _anima;
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //动画结束移除layer
    [self.gradientLayer removeFromSuperlayer];
    /**
     * 强delegate 要置nil
     */
    self.anima.delegate = nil;
}
```

谢谢阅读
有不合适的地方请指教
喜欢请点个赞
抱拳了!w
