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
    }

    
    CGContextAddArc(ctx,x1, y1, CGRectGetWidth(self.originFrame)/2, 0, 2*M_PI, YES);
    CGContextSetFillColorWithColor(ctx, self.circleColor.CGColor);
    CGContextFillPath(ctx);
    

}

-(void)setCurrentFrame:(CGRect)currentFrame{
    _currentFrame = currentFrame;
    [self setNeedsDisplay];
}

- (void)initDefault{
    if (!self.circleColor) {
        self.circleColor = [UIColor redColor];
    }
    if (self.maxDistance==0) {
        self.maxDistance = 140;
    }
}

@end
