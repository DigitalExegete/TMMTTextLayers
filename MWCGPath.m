//
//  MWCGPath.m
//
//  Created by Martin Winter on 14.01.11.
//  Copyright 2011 Martin Winter. All rights reserved.
//
// https://gist.github.com/9626774.git

#import "MWCGPath.h"

void MWCGPathApplierFunction(void *info, const CGPathElement *element)
{
    NSMutableArray *array = (__bridge NSMutableArray *)info;
    CGPathElementType type = element->type;
    CGPoint *points = element->points;

    // Determine number of points for element type.
    NSUInteger pointCount = 0;
    switch (type)
    {
        case kCGPathElementMoveToPoint:
            pointCount = 1;
            break;

        case kCGPathElementAddLineToPoint:
            pointCount = 1;
            break;

        case kCGPathElementAddQuadCurveToPoint:
            pointCount = 2;
            break;

        case kCGPathElementAddCurveToPoint:
            pointCount = 3;
            break;

        case kCGPathElementCloseSubpath:
            pointCount = 0;
            break;

        default:
            [array replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]]; // Set status flag ...
            return; // ... and return.
    }

    // Serialize points.
    NSData *pointsData = [NSData dataWithBytes:points
                                        length:(pointCount * sizeof(CGPoint))];

    // Package type and points.
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:type], @"type",
                                pointsData, @"points",
                                nil];

    // Add dictionary to array.
    [array addObject:dictionary];
}


// Return value is autoreleased.
NSData *MWNSDataFromCGPath(CGPathRef path)
{
    if (path == NULL) return nil;

    // Create array that will hold path elements. Initialize with status flag.
    NSMutableArray *array = [NSMutableArray arrayWithObject:[NSNumber numberWithBool:YES]];

    // Examine path elements.
    CGPathApply(path, (__bridge void *)(array), MWCGPathApplierFunction);

    // Serialize array.
    return [NSKeyedArchiver archivedDataWithRootObject:array];
}


// Caller is responsible for releasing return value.
CGMutablePathRef MWCGPathCreateFromNSData(NSData *data)
{
    if (data == nil) return NULL;

    // Unserialize array.
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    // Recreate path.
    CGMutablePathRef path = CGPathCreateMutable();
    for (NSUInteger elementIndex = 0; elementIndex < [array count]; elementIndex++)
    {
        NSDictionary *dictionary = [array objectAtIndex:elementIndex];
        CGPathElementType type = [(NSNumber *)[dictionary objectForKey:@"type"] intValue];
        CGPoint *points = (CGPoint *)[(NSData *)[dictionary objectForKey:@"points"] bytes];

        switch (type)
        {
            case kCGPathElementMoveToPoint:
                CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                break;

            case kCGPathElementAddLineToPoint:
                CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                break;

            case kCGPathElementAddQuadCurveToPoint:
                CGPathAddQuadCurveToPoint(path, NULL, points[0].x, points[0].y, points[1].x, points[1].y);
                break;

            case kCGPathElementAddCurveToPoint:
                CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y);
                break;

            case kCGPathElementCloseSubpath:
                CGPathCloseSubpath(path);
                break;

            default:
                CGPathRelease(path);
                return NULL;
        }
    }

    return path;
}

