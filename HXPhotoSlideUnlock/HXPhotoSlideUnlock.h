//
//  HXPhotoSlideUnlock.h
//  HXPhotoSlideUnlock
//
//  Created by XIU-Developer on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXPhotoSlideUnlock : UIView
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) BOOL  result;
@end

@interface HXRespondButton : UIButton
@property (nonatomic, assign) BOOL  isHiddenClipImage;
@property (nonatomic, assign) CGFloat  maxWidth;
@property (nonatomic, strong) UIImage *clipImage;
@property (nonatomic, assign) CGRect  clipImageRect;
@property (nonatomic, strong) UIImageView *clipImageView;
@end
