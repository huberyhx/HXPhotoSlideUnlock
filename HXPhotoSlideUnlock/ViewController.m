//
//  ViewController.m
//  HXPhotoSlideUnlock
//
//  Created by XIU-Developer on 2017/4/20.
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
    HXPhotoSlideUnlock *unlockView = [[HXPhotoSlideUnlock alloc]initWithFrame:CGRectMake(66, 180, 220, 55)];
//    unlockView.backgroundColor = [UIColor yellowColor];
    self.imageArray = @[@"image1",@"image2",@"image3",@"image4",@"image5"];
    unlockView.imageArray = self.imageArray;
    [self.view addSubview:unlockView];
}


@end