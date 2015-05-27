//
//  TMMTTextLayer.m
//  TMMTTextLayerTest
//
//  Created by William Jones on 12/19/14.
//  Copyright (c) 2014 Treblotto Music and Music Tech. All rights reserved.
//

#import "TMMTTextLayer.h"

#define kFontSpacing 4
#define kFontSize 26



@interface TMMTTextLayer()
{
	
	id _string;
	
}

@property (assign) NSSize stringSize;
@property (retain) NSMutableArray *runShapeLayerArray;
@property (copy) NSAttributedString *attributedString;
@end

@implementation TMMTTextLayer

-(instancetype)init
{
	
	self = [super init];
	if (self)
	{
		
		_string = nil;
		_attributedString = nil;
		_ligatureType = 1;
		_paragraphAlignment = NSLeftTextAlignment;
		_strokeWidth = 0;
		_textStrokeColor = [[NSColor clearColor] retain];
		_textColor = [[NSColor blackColor] retain];
		_textFont = [[NSFont systemFontOfSize:12] retain];
		_displayBoundingBoxOfText = NO;
		
	}
	return self;
	
}

-(void)dealloc
{
	
	for (CAShapeLayer *sLayer in _runShapeLayerArray)
		[sLayer removeFromSuperlayer];
	
	[_string release];
	[_attributedString release];
	[_textColor release];
	[_textFont release];
	[_textStrokeColor release];
	[_runShapeLayerArray removeAllObjects];
	[_runShapeLayerArray release];
	[super dealloc];
	
}

- (void)setAlignmentMode:(NSString *)alignment
{
	
	if ([alignment isEqualToString:kCAAlignmentCenter])
		self.paragraphAlignment = NSCenterTextAlignment;
	else if ([alignment isEqualToString:kCAAlignmentLeft])
		self.paragraphAlignment = NSLeftTextAlignment;
	else if ([alignment isEqualToString:kCAAlignmentRight])
		self.paragraphAlignment = NSRightTextAlignment;
	else if ([alignment isEqualToString:kCAAlignmentJustified])
		self.paragraphAlignment = NSJustifiedTextAlignment;
	else
		self.paragraphAlignment = NSNaturalTextAlignment;
	
}

- (id)string
{
	
	return _string;
	
}



- (void)setString:(id)string
{
	
	if (![string isEqualToString:_string])
	{
		
		@synchronized (self)
		{
			
			[_string release];
			
			[self.runShapeLayerArray enumerateObjectsUsingBlock:^(CAShapeLayer *tsl, NSUInteger idx, BOOL *stop) {
				
				[tsl removeFromSuperlayer];
				
			}];
			
			[self.runShapeLayerArray removeAllObjects];
			
			_string = [string copy];
			
			
			if ([string isKindOfClass:[NSAttributedString class]])
			{
				self.attributedString = _string;
			}
			else if ([string isKindOfClass:[NSString class]])
			{
				[self updateAttributedString];
				
			}
			else
			{
				[_string release];
				_string = nil;
				
				return;
			}
			
			[self updateTextPath];
			
		}
	}
}

-(void)updateAttributedString
{
	
	if ([[self string] length] < 1)
	{
		[_string release];
		_string = nil;
		self.attributedString = nil;
		return;
		
	}
	
	
	NSMutableDictionary *layerTextAttributeDictionary = [NSMutableDictionary dictionary];
	
	//Text Font
	NSFont *tmmtShapeLayerFont = self.textFont;
	
	
	
	if (!tmmtShapeLayerFont)
		tmmtShapeLayerFont = [NSFont systemFontOfSize:kFontSize];
	[layerTextAttributeDictionary setObject:tmmtShapeLayerFont forKey:NSFontAttributeName];
	
	
	
	//Ligatures
	[layerTextAttributeDictionary setObject:@(self.ligatureType) forKey:NSLigatureAttributeName];
	
	//Foreground Color
	NSColor *foregroundColor = self.textColor;
	
	if (!foregroundColor)
		foregroundColor = [NSColor blackColor];
	
	[layerTextAttributeDictionary setObject:foregroundColor forKey:NSForegroundColorAttributeName];
	
	//Stroke Weight
	[layerTextAttributeDictionary setValue:@(self.strokeWidth) forKey:NSStrokeWidthAttributeName];
	
	//Stroke Color
	[layerTextAttributeDictionary setValue:self.textStrokeColor forKey:NSStrokeColorAttributeName];
	
	if (self.strikethrough)
	{
		//Strikethrough
		[layerTextAttributeDictionary setValue:@(1) forKey:NSStrikethroughStyleAttributeName];
		
		//Strikethrough
		[layerTextAttributeDictionary setValue:self.strikethroughColor forKey:NSStrikethroughColorAttributeName];
	}
	
	
	
	//Paragraph Style
	NSMutableParagraphStyle *tmmtParagraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
	[tmmtParagraphStyle setAlignment:self.paragraphAlignment];
	[layerTextAttributeDictionary setObject:tmmtParagraphStyle forKey:NSParagraphStyleAttributeName];
	
	
	NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc] initWithString:self.string attributes:layerTextAttributeDictionary] autorelease];
	
	[self setAttributedString:attrString];
	
	if (self.path)
		self.stringSize = NSIntegralRect(CGPathGetBoundingBox(self.path)).size;
	
	if (NSEqualRects(self.bounds, NSZeroRect))
	{
		if (!NSEqualSizes(self.stringSize, NSZeroSize))
			self.bounds = NSMakeRect(0, 0, self.stringSize.width, self.stringSize.height);
	}
	
	
}

//--------------------------------------------------------

- (void)setName:(NSString *)name
{
	
	[super setName:name];
	
	[[self runShapeLayerArray] enumerateObjectsUsingBlock:^(CAShapeLayer *tsl, NSUInteger idx, BOOL *stop) {
		
		[tsl setName:[NSString stringWithFormat:@"%@.%lu",name,idx]];
		
	}];
	
}

//--------------------------------------------------------

- (void)setFrame:(CGRect)frame
{
	
	if ((frame.size.height == 0) || (frame.size.width==0))
		return;
	
	[super setFrame:frame];
	[self updateAttributedString];
	[self updateTextPath];
	
}


- (void)setBounds:(CGRect)bounds
{
	
	[super setBounds:bounds];
	[self updateAttributedString];
	[self updateTextPath];
	
}

//--------------------------------------------------------

-(void)setForegroundColor:(CGColorRef)color
{
	
	NSColor *convertingColor = [NSColor colorWithCGColor:color];
	self.textColor = convertingColor;
	[self updateAttributedString];
	[self updateTextPath];
	
}

- (void)updateTextFont:(NSFont *)newFont
{
	
	[self setTextFont:newFont];
	[self updateAttributedString];
	[self updateTextPath];
	
}

//--------------------------------------------------------

- (void)setFont:(CFTypeRef)font
{
	
	CFTypeID cfTID = CFGetTypeID(font);
	
	if (cfTID == CGFontGetTypeID())
	{
		CTFontRef newFont = CTFontCreateWithGraphicsFont((CGFontRef)font, 0, NULL, NULL);
		self.textFont = (NSFont *)newFont;
		CFRelease(newFont);
	}
	else if (cfTID == CTFontGetTypeID())
	{
		self.textFont = (NSFont *)font;
	}
	
	
	
	[self updateAttributedString];
	[self updateTextPath];
}


- (void)setFontSize:(NSUInteger)fontSize
{
	
	NSFont *newFont = [NSFont fontWithName:[self.textFont fontName] size:fontSize];
	[self setTextFont:newFont];
	[self updateAttributedString];
	[self updateTextPath];
	
}

//--------------------------------------------------------


// Things to be careful of:
// 1. The NSForegroundColorAttributeName and the kCTForegroundColorAttributeName ARE DIFFERENT!
-(void)updateTextPath
{
	
	if (!self.attributedString)
		return;
	
	NSUInteger lineCount =  [[self.string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
	
	
	
	CTFramesetterRef layerTextFrameSetter =  CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
	CGMutablePathRef path = CGPathCreateMutable();
	
	if (NSEqualRects(self.bounds, NSZeroRect))
	{
		NSRect bounds = self.bounds;
		if (!NSEqualRects(self.superlayer.bounds, NSZeroRect))
			bounds = [self.superlayer bounds];
		else
			bounds.size = [self.attributedString size];
		
		self.bounds = bounds;
		
	}
	
	CGPathAddRect(path, NULL, CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height));
	CTFrameRef layerTextFrame = CTFramesetterCreateFrame(layerTextFrameSetter, CFRangeMake(0, 0), path, NULL);
	
	
	
	CGPoint * lineOrigins = malloc(lineCount * sizeof(CGPoint));
	CTFrameGetLineOrigins(layerTextFrame, CFRangeMake(0, 0), lineOrigins);
	
	CFArrayRef lineArray = CTFrameGetLines(layerTextFrame);
	
	//If the lines don't equal each other, then we need to make our frame bigger....and call the slow -size method;
	if (CFArrayGetCount(lineArray)==0 && lineCount==1)
	{
		
		NSSize stSize = [self.attributedString size];
		self.bounds = NSMakeRect(0, 0, stSize.width, stSize.height);
		CGPathRelease(path);
		CFRelease(layerTextFrame);
		path = CGPathCreateMutable();
		CGPathAddRect(path, NULL, self.bounds);
		layerTextFrame = CTFramesetterCreateFrame(layerTextFrameSetter, CFRangeMake(0,0), path, NULL);
		lineArray = CTFrameGetLines(layerTextFrame);
	}
	
	self.runShapeLayerArray = [NSMutableArray array];
	CGMutablePathRef textPath = CGPathCreateMutable();
	
	
	for (CFIndex lineIndex = 0; lineIndex < CFArrayGetCount(lineArray); lineIndex++)
	{
		
		CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lineArray, lineIndex);
		
		CFArrayRef runArray = CTLineGetGlyphRuns(line);
		
		// TODO: If there is only one run, just use this layer as the layer.
		for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
		{
			
			CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
			
			// Get FONT for this run
			CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
			
			NSDictionary *runDict = (__bridge NSDictionary *)CTRunGetAttributes(run);
			
			//TODO: Get all of the relevant NSAttributedString Values
			CGColorRef runColor = [(NSColor *)runDict[NSForegroundColorAttributeName] CGColor];
			CGColorRef strokeColor = [(NSColor *)runDict[NSStrokeColorAttributeName] CGColor];
			CGFloat strokeWidthPercent = [runDict[NSStrokeWidthAttributeName] floatValue] / 100;
			
			BOOL fillText = [runDict[NSStrokeWidthAttributeName] floatValue] <= 0;
			
			CGFloat strokeWidth = fabs([(__bridge NSFont *)runFont pointSize] * strokeWidthPercent);
			
			
			
			if(!fillText)
				runColor = [[NSColor clearColor] CGColor];
			
			self.fillColor = runColor;
			self.strokeColor = strokeColor;
			self.lineWidth = strokeWidth;
			
			
			// for each GLYPH in run Get the position, and then place the CAShapeLayer for that run at the position for those glyphs
			CGPoint * runOrigin = malloc(sizeof(CGPoint)*CTRunGetGlyphCount(run));
			CFRange glyphRanges = CFRangeMake(0, CTRunGetGlyphCount(run));
			CTRunGetPositions(run, glyphRanges, runOrigin);
			
			for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
			{
				// get Glyph & Glyph-data
				CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
				CGGlyph glyph;
				
				CTRunGetGlyphs(run, thisGlyphRange, &glyph);
				CGPathRef path = CTFontCreatePathForGlyph(runFont, glyph, NULL);
				
				CGAffineTransform transform = CGAffineTransformMakeTranslation(lineOrigins[lineIndex].x+runOrigin[runGlyphIndex].x, lineOrigins[lineIndex].y+runOrigin[runGlyphIndex].y);
				
				CGPathAddPath(textPath, &transform, path);
				
				
				CGPathRelease(path);
				
			}
			
			
			free(runOrigin);
			
		}
		
		
		
	}
	
	
	self.path = textPath;
	CFRelease(layerTextFrame);
	CFRelease(layerTextFrameSetter);
	CGPathRelease(textPath);
	CGPathRelease(path);
	free(lineOrigins);
	if (self.displayBoundingBoxOfText)
		NSLog(@"Bounding Box: %@", NSStringFromRect(NSIntegralRect(CGPathGetBoundingBox(self.path))));
	
	[self setStringSize:NSIntegralRect(CGPathGetBoundingBox(self.path)).size];
}

@end
