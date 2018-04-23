//
//  ShapeCircle.m
//  testLayer
//
//  Created by FlyOceanFish on 2018/4/17.
//  Copyright © 2018年 FlyOceanFish. All rights reserved.
//

#import "ShapeCircle.h"
@interface ShapeCircle()<CAAnimationDelegate>
{
    NSMutableArray *arrayClouds;
    CGRect _lastRect;
    BOOL _overDistance;
    BOOL _animaling;
    BOOL _moveStartOrigin;
}
@end
@implementation ShapeCircle

-(void)drawInContext:(CGContextRef)ctx{
    
    [self initDefault];
    
    CGFloat r1 = CGRectGetWidth(self.originFrame)/2.0;
    CGFloat r2 = CGRectGetWidth(self.currentFrame)/2.0;
    
    CGFloat x1 = self.originFrame.origin.x+r1;
    CGFloat y1 = self.originFrame.origin.y+r1;
    CGFloat x2 = self.currentFrame.origin.x+r2;
    CGFloat y2 = self.currentFrame.origin.y+r2;
    
    CGFloat d = sqrtf(powf(y1-y2, 2)+powf(x2-x1, 2));
    
    if (CGRectGetWidth(self.currentFrame)>0&&d<self.maxDistance) {
        _overDistance = false;
        _lastRect = self.currentFrame;
        
        CGFloat cos0 = (x2-x1)/d;
        CGFloat sin0 = (y1-y2)/d;
        
        CGPoint pointA = CGPointMake(x1-sin0*r1,y1-cos0*r1);
        CGPoint pointB = CGPointMake(x1+sin0*r1, y1+cos0*r1);
        CGPoint pointC = CGPointMake(x2-sin0*r2, y2-cos0*r2);
        CGPoint pointD = CGPointMake(x2+sin0*r2, y2+cos0*r2);
        
        CGFloat sinA= (pointA.y-pointC.y)/d;
        CGFloat cosA = (pointC.x-pointA.x)/d;
        
        CGFloat sinB = (pointB.y-pointD.y)/d;
        CGFloat cosB = (pointD.x-pointB.x)/d;
        
        
        CGPoint pointO = CGPointMake(pointA.x+cosA*d/2.0, pointA.y-sinA*d/2.0);
        CGPoint pointP = CGPointMake(pointB.x+cosB*d/2.0, pointB.y-sinB*d/2.0);
        
        CGFloat maxOffx = r1;
        CGFloat maxOffy = r1;
        CGFloat maxD = 8*r1;
        CGFloat factor = MIN(maxD, d)/maxD;
        
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:pointA];
        CGPoint pointOffO;
        CGPoint pointOffP;
        
        if(x1>x2&&y1>y2){
            pointOffO = CGPointMake(pointO.x+maxOffx*factor, pointO.y-maxOffy*factor);
            pointOffP = CGPointMake(pointP.x-maxOffx*factor, pointP.y+maxOffy*factor);
        }else if (x1<x2&&y2<y1){
            pointOffO = CGPointMake(pointO.x+maxOffx*factor, pointO.y+maxOffy*factor);
            pointOffP = CGPointMake(pointP.x-maxOffx*factor, pointP.y-maxOffy*factor);
        }else if (x1>x2&&y1<y2) {
            pointOffO = CGPointMake(pointO.x-maxOffx*factor, pointO.y-maxOffy*factor);
            pointOffP = CGPointMake(pointP.x+maxOffx*factor, pointP.y+maxOffy*factor);
        }else{
            pointOffO = CGPointMake(pointO.x-maxOffx*factor, pointO.y+maxOffy*factor);
            pointOffP = CGPointMake(pointP.x+maxOffx*factor, pointP.y-maxOffy*factor);
        }
        [ovalPath addQuadCurveToPoint:pointC controlPoint:pointOffO];
        [ovalPath addLineToPoint:pointD];
        [ovalPath addQuadCurveToPoint:pointB controlPoint:pointOffP];
        [ovalPath closePath];
        CGContextAddPath(ctx, ovalPath.CGPath);
//        CGContextSetFillColorWithColor(ctx, [UIColor orangeColor].CGColor);
        CGContextSetFillColorWithColor(ctx, self.circleColor.CGColor);
        CGContextFillPath(ctx);
        CGContextAddArc(ctx,x2, y2, CGRectGetWidth(self.currentFrame)/2, 0, 2*M_PI, YES);
        CGContextSetFillColorWithColor(ctx, self.circleColor.CGColor);
        CGContextFillPath(ctx);
    }else{
        _overDistance = true;
    }
    
    CGContextAddArc(ctx,x1, y1, CGRectGetWidth(self.originFrame)/2, 0, 2*M_PI, YES);
    CGContextSetFillColorWithColor(ctx, self.circleColor.CGColor);
    CGContextFillPath(ctx);
    

}

-(void)setCurrentFrame:(CGRect)currentFrame{
    if (fabs(self.originFrame.origin.x-currentFrame.origin.x)<10) {
        _moveStartOrigin = true;
    }
    if (_moveStartOrigin) {
        if (!_overDistance) {
            _currentFrame = currentFrame;
            [self setNeedsDisplay];
        }
        
        if ((CGRectGetWidth(currentFrame)==0&&CGRectGetWidth(_lastRect)>0)||(_overDistance&&_animaling)) {
            _moveStartOrigin = false;
            [self animalLayerExplode];
        }
    }
}

- (void)initDefault{
    if (!self.circleColor) {
        self.circleColor = [UIColor redColor];
    }
    if (self.maxDistance==0) {
        self.maxDistance = 140;
    }
    _animaling = true;
}
- (void)animalLayerExplode{
    _animaling = false;
    int width = 8;
    CALayer *layer = [CALayer layer];
    layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"cloud"].CGImage);
    layer.frame = CGRectMake(_lastRect.origin.x+CGRectGetWidth(_lastRect)/2-14,_lastRect.origin.y+CGRectGetWidth(_lastRect)/2-16, width, width);
    CAReplicatorLayer *layercopy = [CAReplicatorLayer layer];
    layercopy.instanceCount = 2;
    layercopy.instanceDelay = 0.08;
    layercopy.instanceTransform = CATransform3DMakeTranslation(22, 3, 0);
    layercopy.frame = CGRectMake(0, 0, 38, width);
    [layercopy addSublayer:layer];
    
    //    [self.view.layer addSublayer:layercopy];
    
    CAReplicatorLayer *layercopy2 = [CAReplicatorLayer layer];
    layercopy2.instanceCount = 2;
    layercopy.instanceDelay  = 0.1;
    layercopy2.instanceTransform = CATransform3DMakeTranslation(0, 26, 0);
    layercopy2.frame = CGRectMake(0, 0, 38, 30);
    [layercopy2 addSublayer:layercopy];
    
    [self.superlayer addSublayer:layercopy2];
    
    CALayer *layerCenter = [CALayer layer];
    layerCenter.contents = (__bridge id _Nullable)([UIImage imageNamed:@"cloud"].CGImage);
    layerCenter.frame = CGRectMake(_lastRect.origin.x+CGRectGetWidth(_lastRect)/2-4,_lastRect.origin.y+CGRectGetWidth(_lastRect)/2-1, width, width);
    [self.superlayer addSublayer:layerCenter];
    
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim1.fromValue = @1;
    anim1.toValue = @0;
    
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim2.fromValue = @1;
    anim2.toValue = @1.5;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[anim1,anim2];
    group.duration = 0.3;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    group.removedOnCompletion = NO;
    [layer addAnimation:group forKey:nil];
    [layerCenter addAnimation:group forKey:nil];
    
}
#pragma mark - CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    _lastRect = CGRectZero;
    _overDistance = false;
    _animaling = true;
}
@end
