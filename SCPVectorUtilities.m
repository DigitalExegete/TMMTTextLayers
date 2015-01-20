//
//  SCPVectorUtilities.m
//  SCPVectorKit
//
//  Created by Semicolon on 9/10/14.
//  Copyright (c) 2014 Semicolon Productions. All rights reserved.
//

#import "SCPVectorUtilities.h"

static void SCPPathEnumerationApplierFunction(void *info, const CGPathElement *element) {
    void (^block)(CGPathElement) = (__bridge void (^)(CGPathElement))(info);
    block(*element);
}

void SCPPathEnumerateUsingBlock(CGPathRef path, void(^block)(CGPathElement element)) {
    CGPathApply(path, (__bridge void *)(block), SCPPathEnumerationApplierFunction);
}