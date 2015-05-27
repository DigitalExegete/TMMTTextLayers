//
//  MWCGPath.m
//
//  Created by Martin Winter on 14.01.11.
//  Copyright 2011 Martin Winter. All rights reserved.
//
// https://gist.github.com/9626774.git

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NSData *MWNSDataFromCGPath(CGPathRef path);
CGMutablePathRef MWCGPathCreateFromNSData(NSData *data) CF_RETURNS_RETAINED;
