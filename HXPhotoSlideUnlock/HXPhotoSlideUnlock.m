//
//  HXPhotoSlideUnlock.m
//  HXPhotoSlideUnlock
//
//  Created by XIU-Developer on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HXPhotoSlideUnlock.h"

#define BtnHeight 32
#define BtnWidth 72
#define ClipWH 30
#define Space 6
static CGRect clipRect;

@interface HXPhotoSlideUnlock()
@property (nonatomic, strong) HXRespondButton *respondBtn;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage  *clipImage;
@property (nonatomic, strong) UIView *rimView;
@property (nonatomic, strong) UIImageView *successImage;
@end

@implementation HXPhotoSlideUnlock

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.rimView];
        [self.rimView addSubview:self.imageView];
        [self.rimView addSubview:self.respondBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIImage *image = [self getImage];
    CGSize size = image.size;
    self.rimView.frame = CGRectMake(0, 0, size.width, BtnHeight);
    [self.respondBtn setFrame:CGRectMake(0, 0, BtnWidth, BtnHeight)];
    self.respondBtn.maxWidth = size.width;
    self.imageView.frame = CGRectMake(0, 0 - size.height - Space, size.width, size.height);
}

-(void)showImage{
    [self.successImage removeFromSuperview];
    self.imageView.hidden = NO;
    self.respondBtn.isHiddenClipImage = NO;
    UIImage *image = [self getImage];
    CGSize size = image.size;
    NSUInteger clipX = [self getRandomNumber:(BtnWidth) to:(size.width - BtnWidth)];
    NSUInteger clipY = [self getRandomNumber:0 to:(size.height - ClipWH)];
    clipRect = CGRectMake(clipX, clipY, ClipWH, ClipWH);
    [self setUpImageViewWithImage:image Rect:clipRect];
    [self.respondBtn setClipImage:[self getCilpImageWithImage:image Rect:clipRect]];
    CGRect recc  = CGRectMake(21, 0 - (size.height + 6 - clipY), ClipWH, ClipWH);
    self.respondBtn.clipImageRect = recc;
}

-(void)hiddenImage{
    CGRect frame = self.respondBtn.frame;
    CGFloat moveX = frame.origin.x + (BtnWidth - ClipWH)*0.5;
    if (fabs(clipRect.origin.x - moveX) < 5) {//验证成功
        self.imageView.hidden = NO;
        self.respondBtn.isHiddenClipImage = NO;
        [self.rimView addSubview:self.successImage];
        self.respondBtn.userInteractionEnabled = NO;
        self.result = YES;
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

- (void)setUpImageViewWithImage:(UIImage *)image Rect:(CGRect)rect{
    CGSize size = image.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [image drawAtPoint:CGPointZero];
    CGContextClearRect(ctx, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = newImage;
}

- (UIImage *)getCilpImageWithImage:(UIImage *)image  Rect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, imageRef);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)getImage{
    NSString *imageName = self.imageArray[[self getRandomNumber:0 to:self.imageArray.count - 1]];
    return [UIImage imageNamed:imageName];
}

-(unsigned long)getRandomNumber:(unsigned long)from to:(unsigned long)to
{
    return (unsigned long)(from + (arc4random() % (to - from + 1)));
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"image"];
        _imageView.hidden = YES;
        _imageView.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:0.6];
        _imageView.layer.cornerRadius = 9;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UIView *)rimView{
    if (!_rimView) {
        _rimView = [[UIView alloc]init];
        _rimView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _rimView.layer.borderWidth = 0.5;
        _rimView.layer.cornerRadius = 16;
    }
    return _rimView;
}

- (HXRespondButton *)respondBtn{
    if (!_respondBtn) {
        _respondBtn = [HXRespondButton buttonWithType:UIButtonTypeCustom];
        [_respondBtn setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
        [_respondBtn addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchDown];
        [_respondBtn addTarget:self action:@selector(hiddenImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _respondBtn;
}

- (UIImageView *)successImage{
    if (!_successImage) {
        _successImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yes1"]];
        _successImage.frame = CGRectMake(CGRectGetMaxX(self.rimView.frame) + Space, 0, 32, 32);
    }
    return _successImage;
}
@end


@implementation HXRespondButton

- (void)setIsHiddenClipImage:(BOOL)isHiddenClipImage{
    _isHiddenClipImage = isHiddenClipImage;
    self.clipImageView.hidden = _isHiddenClipImage;
}

- (void)setClipImage:(UIImage *)clipImage{
    _clipImage = clipImage;
    self.clipImageView.image = clipImage;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.clipImageView.frame = self.clipImageRect;
}

- (UIImageView *)clipImageView{
    if (!_clipImageView) {
        _clipImageView = [[UIImageView alloc]init];
        _clipImageView.layer.shadowOpacity = 1;
        _clipImageView.layer.shadowOffset = CGSizeMake(0, 0);
        _clipImageView.layer.shadowRadius = 5;
        [self addSubview:_clipImageView];
    }
    return _clipImageView;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGRect temp = self.frame;
    UITouch *touch = [touches anyObject];
    CGPoint prePoint = [touch previousLocationInView:self];
    CGPoint currentPoint = [touch locationInView:self];
    CGFloat move = currentPoint.x - prePoint.x;
    if (move>0) {//向右滑动时
        if ((CGRectGetMaxX(temp) >= self.maxWidth)){//已经在最右边
            return;
        }
        if (CGRectGetMaxX(temp) + move >= self.maxWidth) {
            move = self.maxWidth - CGRectGetMaxX(temp);
        }
    }else{//向左滑动
        if ((temp.origin.x <= 0)) {//已经在最左边
            return;
        }
        if(temp.origin.x + move <= 0){
            move = 0 - temp.origin.x;
        }
    }
    temp.origin.x += move;
    self.frame= temp;
}

@end
