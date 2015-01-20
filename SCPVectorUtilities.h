//
//  SCPVectorUtilities.h
//  SCPVectorKit
//
//  Created by Semicolon on 9/10/14.
//  Copyright (c) 2014 Semicolon Productions. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

/**
 Enumerates over a CGPath using a block. Provides a more convenient alternative to CGPathApply.
 */

void SCPPathEnumerateUsingBlock(CGPathRef path, void(^block)(CGPathElement element));