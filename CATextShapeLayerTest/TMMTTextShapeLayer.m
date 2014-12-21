//
//  TMMTTextShapeLayer.m
//  TMMTTextShapeLayerTest
//
//  Created by William Jones on 12/19/14.
//  Copyright (c) 2014 Treblotto Music and Music Tech. All rights reserved.
//

#import "TMMTTextShapeLayer.h"

#define kFontSpacing 4
#define kFontSize 26



@interface TMMTTextShapeLayer()
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

@implementation TMMTTextShapeLayer

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
		_strokeColor = [[NSColor clearColor] retain];
		_foregroundColor = [[NSColor blackColor] retain];
		
		
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
	NSColor *foregroundColor = self.foregroundColor;
	
	if (!foregroundColor)
		foregroundColor = [NSColor blackColor];

	[layerTextAttributeDictionary setObject:foregroundColor forKey:NSForegroundColorAttributeName];
	
	//Stroke Weight
	[layerTextAttributeDictionary setValue:@(self.strokeWidth) forKey:NSStrokeWidthAttributeName];
	
	//Stroke Color
	[layerTextAttributeDictionary setValue:self.strokeColor forKey:NSStrokeColorAttributeName];
	
	if (self.striketrough)
	{
		//Strikethrough
		[layerTextAttributeDictionary setValue:@(1) forKey:NSStrikethroughStyleAttributeName];
		
		//Strikethrough
		[layerTextAttributeDictionary setValue:self.strikethroughColor forKey:NSStrikethroughColorAttributeName];
	}
	
	
	
	//Paragraph Style
	NSMutableParagraphStyle *digRadParagraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
	[digRadParagraphStyle setAlignment:NSLeftTextAlignment];
	[layerTextAttributeDictionary setObject:digRadParagraphStyle forKey:NSParagraphStyleAttributeName];
	NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc] initWithString:self.string attributes:layerTextAttributeDictionary] autorelease];
	
	
	
	if (attributedString)
		[attributedString release];
		
	attributedString = [attrString copy];
	
	self.stringSize = [attributedString size];
	NSRect bounds = NSMakeRect(0, 0, self.stringSize.width, self.stringSize.height);
	self.bounds = NSIntegralRect( bounds );
	
}

//--------------------------------------------------------


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
	CGPathAddRect(path, NULL, CGRectMake(0.0, 0.0, self.stringSize.width, self.stringSize.height));
	CTFrameRef layerTextFrame = CTFramesetterCreateFrame(layerTextFrameSetter, CFRangeMake(0, 0), path, NULL);
	
	CFAutorelease(path);
	CFAutorelease(layerTextFrame);
	CFAutorelease(layerTextFrameSetter);
	
	
	CGPoint * lineOrigins = malloc(lineCount * sizeof(CGPoint));
	CTFrameGetLineOrigins(layerTextFrame, CFRangeMake(0, 0), lineOrigins);
	
	CFArrayRef lineArray = CTFrameGetLines(layerTextFrame);

	self.runShapeLayerArray = [NSMutableArray array];


	for (CFIndex lineIndex = 0; lineIndex < CFArrayGetCount(lineArray); lineIndex++)
	{
	
		CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lineArray, lineIndex);
		
		CFArrayRef runArray = CTLineGetGlyphRuns(line);
		
		// for each RUN make a new CAShapeLayer Sublayer
		// TODO: If there is only one run, just use this layer as the layer.
		for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
		{
			CGMutablePathRef textPath = CGPathCreateMutable();

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
				
				CGAffineTransform transform = CGAffineTransformMakeTranslation(runOrigin[runGlyphIndex].x-runOrigin[0].x, 0);
				CGPathAddPath(textPath, &transform, path);
				CGPathRelease(path);
				
			}
			
			//Create the CAShapeLayer sublayer;
			CAShapeLayer *runShapeLayer = [CAShapeLayer layer];
			[self addSublayer:runShapeLayer];
			[self.runShapeLayerArray addObject:runShapeLayer];
			
			[runShapeLayer setBorderWidth:0];
			runShapeLayer.path = textPath;
			CGPathRelease(textPath);
			NSRect frame = CGPathGetBoundingBox(runShapeLayer.path);
			frame.origin = CGPointMake(lineOrigins[lineIndex].x+runOrigin[0].x, lineOrigins[lineIndex].y+runOrigin[0].y);
			frame = NSIntegralRect(frame);
			runShapeLayer.frame = frame;
			
			[runShapeLayer setFillColor:runColor];
			[runShapeLayer setStrokeColor:strokeColor];
			[runShapeLayer setLineWidth:strokeWidth];
			free(runOrigin);
		
			
		}


	}

	free(lineOrigins);
}

@end
