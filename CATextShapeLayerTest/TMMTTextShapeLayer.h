//
//  CATextShapeLayer.h
//  CATextShapeLayerTest
//
//  Created by William Jones on 12/19/14.
//  Copyright (c) 2014 Treblotto Music and Music Tech. All rights reserved.
//	~TM|MT~



#import <Quartz/Quartz.h>

/*!
 
 @header CATextShapeLayer
 
 @brief A CALayer subclass that renders text as a CGPath, instead of compositing the text into a backing store like other classes. *cough*CATextLayer*cough*
 
 
 @discussion This will be a multi-phased project.  Currently there is support for whatever the font natively supports.
 @par 1. Creating the TextShapeLayer to render text as a path - Completed 12/19/14
 @par 2. Altering the behavior so that it can accept attributed strings and add different shape layers for each run.
 @par 3. TBD.
 
 
 
 */
@interface TMMTTextShapeLayer : CALayer

/*!
 
 @brief Set the text (la ti doooo!) that you want to render to this property.
 @param string the text you want displayed in the layer.  It can be an @c NSAttributedString or a @c NSString.  No @c CFAttributedStringRefs please.
 
 */
@property (copy) id string;

@property (strong) NSFont *textFont;
@property (strong) NSColor *foregroundColor;
@property (strong) NSColor *strokeColor;
@property (assign) NSInteger strokeWidth;
@property (copy) NSString *paragraphAlignment;
@property (assign) NSUInteger ligatureType;


/*!
 
 @brief does nothing
 
 */
@property (assign) BOOL underlined;
@property (assign) BOOL striketrough;



//@property (strong) NSAttributedString *attrString;

@end
