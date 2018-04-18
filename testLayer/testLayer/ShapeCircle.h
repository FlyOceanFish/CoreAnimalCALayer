//
//  ShapeCircle.h
//  testLayer
//
//  Created by FlyOceanFish on 2018/4/17.
//  Copyright © 2018年 FlyOceanFish. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ShapeCircle : CALayer
@property (nonatomic,assign)CGRect currentFrame;
@property (nonatomic,assign)CGRect originFrame;
@property (nonatomic,assign)CGFloat maxDistance;
@property (nonatomic,strong)UIColor *circleColor;
@end
