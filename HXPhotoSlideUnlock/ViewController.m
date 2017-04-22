//
//  ViewController.m
//  HXPhotoSlideUnlock
//
//  Created by XIU-Developer on 2017/4/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "HXPhotoSlideUnlock.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *imageArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     view中包括拖动框和拖动按钮
     拖动框的宽度和传入的图片宽度一样
     所以创建的时候 view的宽度尽量不要小于图片宽度
     */
    HXPhotoSlideUnlock *unlockView = [[HXPhotoSlideUnlock alloc]initWithFrame:CGRectMake(66, 180, 220, 55)];
    self.imageArray = @[@"image1",@"image2",@"image3",@"image4",@"image5"];
    unlockView.imageArray = self.imageArray;
    [self.view addSubview:unlockView];
}


@end
