//
//  TMMTCClefLayer.m
//  TMMTTextLayers
//
//  Created by William Jones on 1/8/15.
//  Copyright (c) 2015 Treblotto Music and Music Tech. All rights reserved.
//

#import "TMMTCClefLayer.h"

@implementation TMMTCClefLayer

- (instancetype)init
{
	
	self = [super init];
	if (self)
	{
		[self addCClefToLayer];
		[self setFillColor:[[NSColor colorWithRed:0 green:0.35 blue:0 alpha:1] CGColor]];
		self.strokeColor = [[NSColor blackColor] CGColor];
		self.lineWidth = 1;
		[self setBorderWidth:1];
//		[self setBounds:NSMakeRect(0, 0, 128, 160)];
		[self setShadowPath:self.path];
		[self setShadowColor:[[NSColor blackColor] CGColor]];
		[self setShadowRadius:5];
		[self setShadowOffset:CGSizeMake(4, 4)];
		[self setShadowOpacity:0.5];
		
	}
	return self;
}



-(void)addCClefToLayer
{

	[self setTextFont:[NSFont fontWithName:@"Guido2" size:96]];
	[self setString:@"B & ?"];
	
	[self setForegroundColor:[[NSColor blackColor]CGColor]];
	
	
//	NSBezierPath* textPath = NSBezierPath.bezierPath;
//	[textPath moveToPoint: NSMakePoint(0, 0)];
//	[textPath lineToPoint: NSMakePoint(0, 128)];
//	[textPath lineToPoint: NSMakePoint(15.97, 128)];
//	[textPath lineToPoint: NSMakePoint(15.97, 0)];
//	[textPath lineToPoint: NSMakePoint(0, 0)];
//	[textPath closePath];
//	[textPath moveToPoint: NSMakePoint(29.07, 0)];
//	[textPath lineToPoint: NSMakePoint(24.02, 0)];
//	[textPath lineToPoint: NSMakePoint(24.02, 128)];
//	[textPath lineToPoint: NSMakePoint(29.07, 128)];
//	[textPath lineToPoint: NSMakePoint(29.07, 65.13)];
//	[textPath curveToPoint: NSMakePoint(46, 93.55) controlPoint1: NSMakePoint(36.9, 69.41) controlPoint2: NSMakePoint(42.54, 78.88)];
//	[textPath lineToPoint: NSMakePoint(46.27, 93.55)];
//	[textPath curveToPoint: NSMakePoint(50.37, 82.23) controlPoint1: NSMakePoint(46.82, 89.19) controlPoint2: NSMakePoint(48.18, 85.42)];
//	[textPath curveToPoint: NSMakePoint(60.74, 75.82) controlPoint1: NSMakePoint(53.1, 78.29) controlPoint2: NSMakePoint(56.55, 76.15)];
//	[textPath curveToPoint: NSMakePoint(72.62, 84.5) controlPoint1: NSMakePoint(66.75, 75.32) controlPoint2: NSMakePoint(70.7, 78.21)];
//	[textPath curveToPoint: NSMakePoint(73.98, 100.46) controlPoint1: NSMakePoint(73.34, 87.09) controlPoint2: NSMakePoint(73.8, 92.42)];
//	[textPath curveToPoint: NSMakePoint(71.8, 116.18) controlPoint1: NSMakePoint(74.16, 107.59) controlPoint2: NSMakePoint(73.43, 112.83)];
//	[textPath curveToPoint: NSMakePoint(58.56, 124.23) controlPoint1: NSMakePoint(69.52, 121.04) controlPoint2: NSMakePoint(65.11, 123.72)];
//	[textPath curveToPoint: NSMakePoint(53.23, 123.03) controlPoint1: NSMakePoint(57.1, 124.31) controlPoint2: NSMakePoint(55.33, 123.91)];
//	[textPath curveToPoint: NSMakePoint(50.09, 119.7) controlPoint1: NSMakePoint(51.14, 122.15) controlPoint2: NSMakePoint(50.09, 121.04)];
//	[textPath curveToPoint: NSMakePoint(52.69, 116.81) controlPoint1: NSMakePoint(50.09, 119.37) controlPoint2: NSMakePoint(50.96, 118.4)];
//	[textPath curveToPoint: NSMakePoint(55.28, 111.4) controlPoint1: NSMakePoint(54.42, 115.22) controlPoint2: NSMakePoint(55.28, 113.41)];
//	[textPath curveToPoint: NSMakePoint(52.82, 106.25) controlPoint1: NSMakePoint(55.28, 109.22) controlPoint2: NSMakePoint(54.46, 107.5)];
//	[textPath curveToPoint: NSMakePoint(46.82, 104.36) controlPoint1: NSMakePoint(51.19, 104.99) controlPoint2: NSMakePoint(49.18, 104.36)];
//	[textPath curveToPoint: NSMakePoint(40.88, 106.88) controlPoint1: NSMakePoint(44.45, 104.36) controlPoint2: NSMakePoint(42.47, 105.2)];
//	[textPath curveToPoint: NSMakePoint(38.49, 112.66) controlPoint1: NSMakePoint(39.29, 108.55) controlPoint2: NSMakePoint(38.49, 110.48)];
//	[textPath curveToPoint: NSMakePoint(46.82, 124.35) controlPoint1: NSMakePoint(38.49, 117.52) controlPoint2: NSMakePoint(41.27, 121.42)];
//	[textPath curveToPoint: NSMakePoint(62.51, 128) controlPoint1: NSMakePoint(51.46, 126.78) controlPoint2: NSMakePoint(56.69, 128)];
//	[textPath curveToPoint: NSMakePoint(83.88, 119.76) controlPoint1: NSMakePoint(71.34, 128) controlPoint2: NSMakePoint(78.46, 125.25)];
//	[textPath curveToPoint: NSMakePoint(91.86, 98.07) controlPoint1: NSMakePoint(89.29, 114.27) controlPoint2: NSMakePoint(91.95, 107.04)];
//	[textPath curveToPoint: NSMakePoint(84.9, 79.53) controlPoint1: NSMakePoint(91.77, 90.78) controlPoint2: NSMakePoint(89.45, 84.6)];
//	[textPath curveToPoint: NSMakePoint(66.88, 70.92) controlPoint1: NSMakePoint(80.35, 74.46) controlPoint2: NSMakePoint(74.34, 71.59)];
//	[textPath curveToPoint: NSMakePoint(52.82, 73.3) controlPoint1: NSMakePoint(62.7, 70.58) controlPoint2: NSMakePoint(58.01, 71.38)];
//	[textPath lineToPoint: NSMakePoint(41.63, 64.13)];
//	[textPath lineToPoint: NSMakePoint(52.82, 54.82)];
//	[textPath curveToPoint: NSMakePoint(66.88, 57.21) controlPoint1: NSMakePoint(58.01, 56.75) controlPoint2: NSMakePoint(62.7, 57.55)];
//	[textPath curveToPoint: NSMakePoint(85.17, 48.41) controlPoint1: NSMakePoint(74.34, 56.54) controlPoint2: NSMakePoint(80.44, 53.61)];
//	[textPath curveToPoint: NSMakePoint(92, 29.93) controlPoint1: NSMakePoint(89.63, 43.38) controlPoint2: NSMakePoint(91.91, 37.22)];
//	[textPath curveToPoint: NSMakePoint(83.94, 8.3) controlPoint1: NSMakePoint(92.09, 21.04) controlPoint2: NSMakePoint(89.4, 13.83)];
//	[textPath curveToPoint: NSMakePoint(62.51, 0) controlPoint1: NSMakePoint(78.48, 2.77) controlPoint2: NSMakePoint(71.34, 0)];
//	[textPath curveToPoint: NSMakePoint(46.68, 3.77) controlPoint1: NSMakePoint(56.69, 0) controlPoint2: NSMakePoint(51.41, 1.26)];
//	[textPath curveToPoint: NSMakePoint(38.49, 15.47) controlPoint1: NSMakePoint(41.22, 6.71) controlPoint2: NSMakePoint(38.49, 10.6)];
//	[textPath curveToPoint: NSMakePoint(40.88, 21.38) controlPoint1: NSMakePoint(38.49, 17.73) controlPoint2: NSMakePoint(39.29, 19.7)];
//	[textPath curveToPoint: NSMakePoint(46.82, 23.89) controlPoint1: NSMakePoint(42.47, 23.05) controlPoint2: NSMakePoint(44.45, 23.89)];
//	[textPath curveToPoint: NSMakePoint(52.82, 21.94) controlPoint1: NSMakePoint(49.18, 23.89) controlPoint2: NSMakePoint(51.19, 23.24)];
//	[textPath curveToPoint: NSMakePoint(55.28, 16.72) controlPoint1: NSMakePoint(54.46, 20.64) controlPoint2: NSMakePoint(55.28, 18.9)];
//	[textPath curveToPoint: NSMakePoint(52.69, 11.32) controlPoint1: NSMakePoint(55.28, 14.71) controlPoint2: NSMakePoint(54.42, 12.91)];
//	[textPath curveToPoint: NSMakePoint(50.09, 8.3) controlPoint1: NSMakePoint(50.96, 9.72) controlPoint2: NSMakePoint(50.09, 8.72)];
//	[textPath curveToPoint: NSMakePoint(53.51, 4.9) controlPoint1: NSMakePoint(50.09, 7.04) controlPoint2: NSMakePoint(51.23, 5.91)];
//	[textPath curveToPoint: NSMakePoint(58.56, 3.65) controlPoint1: NSMakePoint(55.42, 4.07) controlPoint2: NSMakePoint(57.1, 3.65)];
//	[textPath curveToPoint: NSMakePoint(73.98, 28.29) controlPoint1: NSMakePoint(69.2, 3.65) controlPoint2: NSMakePoint(74.34, 11.86)];
//	[textPath curveToPoint: NSMakePoint(72.48, 44.01) controlPoint1: NSMakePoint(73.8, 36) controlPoint2: NSMakePoint(73.3, 41.24)];
//	[textPath curveToPoint: NSMakePoint(60.74, 52.31) controlPoint1: NSMakePoint(70.57, 50.04) controlPoint2: NSMakePoint(66.66, 52.81)];
//	[textPath curveToPoint: NSMakePoint(50.37, 45.89) controlPoint1: NSMakePoint(56.55, 51.97) controlPoint2: NSMakePoint(53.1, 49.83)];
//	[textPath curveToPoint: NSMakePoint(46.27, 34.45) controlPoint1: NSMakePoint(48.18, 42.71) controlPoint2: NSMakePoint(46.82, 38.89)];
//	[textPath lineToPoint: NSMakePoint(46, 34.45)];
//	[textPath curveToPoint: NSMakePoint(29.07, 62.99) controlPoint1: NSMakePoint(42.81, 48.79) controlPoint2: NSMakePoint(37.17, 58.3)];
//	[textPath lineToPoint: NSMakePoint(29.07, 0)];
//	[textPath closePath];
//	
//	NSAffineTransform *at = [NSAffineTransform transform];
//	[at translateXBy:18 yBy:24];
//	[textPath transformUsingAffineTransform:at];
//	self.path = [textPath CGPath];
	
}

@end
