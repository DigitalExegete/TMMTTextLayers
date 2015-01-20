//
//  NSBezierPath+SCPVectorKit.h
//  SCPVectorKit
//
//  Created by Semicolon on 9/27/14.
//  Copyright (c) 2014 Semicolon Productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (SCPVectorKit)

-(instancetype)initWithCGPath:(CGPathRef)path;
@property (readonly) CGPathRef CGPath;

@end
