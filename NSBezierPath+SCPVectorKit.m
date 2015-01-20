//
//  NSBezierPath+SCPVectorKit.m
//  SCPVectorKit
//
//  Created by Semicolon on 9/27/14.
//  Copyright (c) 2014 Semicolon Productions. All rights reserved.
//

#import "NSBezierPath+SCPVectorKit.h"
#import "SCPVectorUtilities.h"

@implementation NSBezierPath (SCPVectorKit)

-(instancetype)initWithCGPath:(CGPathRef)path {
    self = [self init];

    if(self) {
        SCPPathEnumerateUsingBlock(path, ^(CGPathElement element) {

            switch (element.type) {
                case kCGPathElementMoveToPoint:
                    [self moveToPoint:element.points[0]];
                    break;

                case kCGPathElementAddLineToPoint:
                    [self lineToPoint:element.points[0]];
                    break;

                case kCGPathElementAddQuadCurveToPoint:
                {
                    CGPoint fromPoint = [self currentPoint];
                    CGPoint controlPoint = element.points[0];
                    CGPoint toPoint = element.points[1];

                    CGFloat x1 = fromPoint.x + (2.0 / 3.0) * (controlPoint.x - fromPoint.x);
                    CGFloat y1 = fromPoint.y + (2.0 / 3.0) * (controlPoint.y - fromPoint.y);

                    CGFloat x2 = toPoint.x + (2.0 / 3.0) * (controlPoint.x - toPoint.x);
                    CGFloat y2 = toPoint.y + (2.0 / 3.0) * (controlPoint.y - toPoint.y);

                    [self curveToPoint:toPoint controlPoint1:CGPointMake(x1, y1) controlPoint2:CGPointMake(x2, y2)];

                    break;
                }

                case kCGPathElementAddCurveToPoint:
                    [self curveToPoint:element.points[2] controlPoint1:element.points[0] controlPoint2:element.points[1]];
                    break;

                case kCGPathElementCloseSubpath:
                    [self closePath];
                    break;
            }
        });
    }

    return self;
}

-(CGPathRef)CGPath {
    CGMutablePathRef path = CGPathCreateMutable();

    NSInteger elementCount = self.elementCount;
    CGPoint points[3];

    for(NSInteger i = 0; i < elementCount; i++) {

        switch([self elementAtIndex:i associatedPoints:points]) {
            case NSMoveToBezierPathElement:
                CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                break;

            case NSLineToBezierPathElement:
                CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                break;

            case NSCurveToBezierPathElement:
                CGPathAddCurveToPoint(path, NULL,
                                      points[0].x, points[0].y,
                                      points[1].x, points[1].y,
                                      points[2].x, points[2].y);
                break;

            case NSClosePathBezierPathElement:
                CGPathCloseSubpath(path);
                break;
        }
    }

    CFAutorelease(path);
    return path;
}

@end
