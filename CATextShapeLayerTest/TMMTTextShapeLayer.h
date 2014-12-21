//
//  CATextShapeLayer.h
//  CATextShapeLayerTest
//
//  Created by William Jones on 12/19/14.
//  Copyright (c) 2014 Treblotto Music and Music Tech. All rights reserved.
//	~TM|MT~



#import <Quartz/Quartz.h>
#import "NSBezierPath+Boolean.h"
#import "NSBezierPath+Utilities.h"

/*!
 
 @header TMMTTextShapeLayer
 
 @brief A CALayer subclass that renders text as a CGPath, instead of compositing the text into a backing store like other classes. *cough*CATextLayer*cough*
 
 
 @discussion This will be a multi-phased project.  Currently there is support for whatever the font natively supports.
 @par 1. Creating the TextShapeLayer to render text as a path - Completed 12/19/14
 @par 2. Altering the behavior so that it can accept attributed strings and add different shape layers for each run. - Completed 12/20/14
 @par 3. Adding Support For strikethrough and underline
 
 
 
 
 */
@interface TMMTTextShapeLayer : CALayer

/*!
 
 @brief Set the text (la ti doooo!) that you want to render to this property.
 @param string the text you want displayed in the layer.  It can be an @c NSAttributedString or a @c NSString.  No @c CFAttributedStringRefs please.
 
 */
@property (copy) id string;

@property (retain) NSFont *textFont;
@property (retain) NSColor *foregroundColor;
@property (retain) NSColor *strokeColor;
@property (assign) CGFloat strokeWidth;
@property (assign) NSTextAlignment paragraphAlignment;
@property (assign) NSUInteger ligatureType;


/*!
 
 @brief currently not implemented does nothing
 
 */
@property (assign) BOOL underlined;
@property (assign) BOOL striketrough;
@property (retain) NSColor *strikethroughColor;


@end
