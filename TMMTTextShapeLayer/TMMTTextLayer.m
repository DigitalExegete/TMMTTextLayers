//
//  TMMTTextShapeLayer.m
//  TMMTTextShapeLayerTest
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
	
	/*!
	 
	 @brief This is the string that is actually rendered.  If a user sets the @c string property to an NSString, this class will create an NSAttributedString based on the various properties of this class.
	 
	 */
	NSAttributedString *attributedString;
	
}

@property (assign) NSSize stringSize;
@property (retain) NSMutableArray *runShapeLayerArray;
@end

@implementation TMMTTextLayer

-(instancetype)init
{
	
	self = [super init];
	if (self)
	{
		
		_string = nil;
		attributedString = nil;
		_ligatureType = 1;
		_paragraphAlignment = NSLeftTextAlignment;
		_strokeWidth = 0;
		_textStrokeColor = [[NSColor clearColor] retain];
		_textColor = [[NSColor blackColor] retain];
		_textFont = [[NSFont systemFontOfSize:12] retain];
		
		
	}
	return self;
	
}

-(void)dealloc
{
	
	for (CAShapeLayer *sLayer in _runShapeLayerArray)
		[sLayer removeFromSuperlayer];
	
	[_string release];
	[attributedString release];
	
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
		[self.runShapeLayerArray enumerateObjectsUsingBlock:^(CAShapeLayer *tsl, NSUInteger idx, BOOL *stop) {
			
			[tsl removeFromSuperlayer];
			
		}];
		
		[self.runShapeLayerArray removeAllObjects];
		
		_string = [string copy];
		
		
		if ([string isKindOfClass:[NSAttributedString class]])
		{
			attributedString = _string;
		}
		else if ([string isKindOfClass:[NSString class]])
		{
			[self updateAttributedString];
			
		}
		else
		{	_string = nil;
			return;
		}
		
		[self updateTextPath];
		
	}
}

-(void)updateAttributedString
{
	
	if ([[self string] length] < 1)
	{
		_string = nil;
		attributedString = nil;
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
	
	if (self.striketrough)
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
	
	
	
	if (attributedString)
		[attributedString release];
		
	attributedString = [attrString copy];
	
	self.stringSize = [attributedString size];
	
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

-(void)setForegroundColor:(CGColorRef)color
{
	
	NSColor *convertingColor = [NSColor colorWithCGColor:color];
	self.textColor = convertingColor;
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
	
	if (!attributedString)
		return;
	
	NSUInteger lineCount =  [[self.string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
	
	
	
	CTFramesetterRef layerTextFrameSetter =  CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height));
	CTFrameRef layerTextFrame = CTFramesetterCreateFrame(layerTextFrameSetter, CFRangeMake(0, 0), path, NULL);
	
	CFAutorelease(path);
	CFAutorelease(layerTextFrame);
	CFAutorelease(layerTextFrameSetter);
	
	
	CGPoint * lineOrigins = malloc(lineCount * sizeof(CGPoint));
	CTFrameGetLineOrigins(layerTextFrame, CFRangeMake(0, 0), lineOrigins);
	
	CFArrayRef lineArray = CTFrameGetLines(layerTextFrame);

	self.runShapeLayerArray = [NSMutableArray array];
	CGMutablePathRef textPath = CGPathCreateMutable();


	for (CFIndex lineIndex = 0; lineIndex < CFArrayGetCount(lineArray); lineIndex++)
	{
	
		CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lineArray, lineIndex);
		
		CFArrayRef runArray = CTLineGetGlyphRuns(line);
		
		// for each RUN make a new CAShapeLayer Sublayer
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
			
			CGFloat strokeWidth = fabsf([(__bridge NSFont *)runFont pointSize] * strokeWidthPercent);
			

			
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
			
		}

		

	}
	self.path = textPath;
	CGPathRelease(textPath);
	free(lineOrigins);
}

@end
