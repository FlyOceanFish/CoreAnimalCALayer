//
//  EmmitViewController.m
//  testLayer
//
//  Created by YTO on 2018/4/19.
//  Copyright © 2018年 FlyOceanFish. All rights reserved.
//

#import "EmmitViewController.h"

@interface EmmitViewController ()

@end

@implementation EmmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)animalCopyLayerExplode{
    CALayer *layer = [CALayer layer];
    layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"cloud"].CGImage);
//    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.frame = CGRectMake(100, 100, 12, 12);
//    [self.view.layer addSublayer:layer];
    CAReplicatorLayer *layercopy = [CAReplicatorLayer layer];
    layercopy.instanceCount = 2;
    layercopy.instanceDelay = 0.08;
    layercopy.instanceTransform = CATransform3DMakeTranslation(26, 3, 0);
    layercopy.frame = CGRectMake(0, 0, 42, 12);
    [layercopy addSublayer:layer];
//    [self.view.layer addSublayer:layercopy];
    
    CAReplicatorLayer *layercopy2 = [CAReplicatorLayer layer];
    layercopy2.instanceCount = 2;
    layercopy.instanceDelay  = 0.1;
    layercopy2.instanceTransform = CATransform3DMakeTranslation(0, 26, 0);
    layercopy2.frame = CGRectMake(0, 0, 38, 30);
    [layercopy2 addSublayer:layercopy];
    [self.view.layer addSublayer:layercopy2];


    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim1.fromValue = @1;
    anim1.toValue = @0;
    
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim2.fromValue = @1;
    anim2.toValue = @1.5;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[anim1,anim2];
    group.duration = 0.5;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [layer addAnimation:group forKey:nil];
}

- (void)emitterAnimal
{
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    //发射点的位置
    snowEmitter.emitterPosition = CGPointMake(200,200);
    //
    snowEmitter.emitterSize = CGSizeMake(100,100);
    snowEmitter.emitterShape = kCAEmitterLayerRectangle;
    snowEmitter.emitterMode = kCAEmitterLayerOutline;
    
//    snowEmitter.shadowColor = [UIColor whiteColor].CGColor;
//    snowEmitter.shadowOffset = CGSizeMake(0.0, 1.0);
//    snowEmitter.shadowRadius = 0.0;
//    snowEmitter.shadowOpacity = 1.0;
    
    CAEmitterCell *snowCell = [CAEmitterCell emitterCell];
    
    snowCell.birthRate = 0.1; //每秒出现多少个粒子
    snowCell.lifetime = 10; // 粒子的存活时间
//    snowCell.lifetimeRange = 1;
//    snowCell.velocity = -10; //速度
//    snowCell.velocityRange = 10; // 平均速度
//    snowCell.yAcceleration = 2;//粒子在y方向上的加速度
//    snowCell.emissionRange = 0.5 * M_PI; //发射的弧度
//    snowCell.spinRange = 0.25 * M_PI; // 粒子的平均旋转速度
    snowCell.contents = (id)[UIImage imageNamed:@"cloud"].CGImage;
//    snowCell.alphaSpeed = 0.6;
    snowCell.scale = 0.3;
//    snowCell.scaleRange = 0.08;
//    snowCell.repeatCount = 1;
//    snowCell.color = [UIColor colorWithRed:0.6 green:0.658 blue:0.743 alpha:1.0].CGColor;
    
    snowEmitter.emitterCells = @[snowCell];
    
    [self.view.layer insertSublayer:snowEmitter atIndex:0];
//    [snowEmitter performSelector:@selector(removeFromSuperlayer) withObject:nil afterDelay:1];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self animalCopyLayerExplode];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
