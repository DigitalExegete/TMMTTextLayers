//
//  AppDelegate.m
//  CATextShapeLayerTest
//
//  Created by William Jones on 12/19/14.
//  Copyright (c) 2014 Treblotto Music and Music Tech. All rights reserved.
//	Released under the MIT License
//
///////////////////////////////////////////////////////////////////////////




#import "AppDelegate.h"
#import "TMMTTextLayer.h"
#import "TMMTCClefLayer.h"

@interface AppDelegate ()

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *layerView;
@property (assign) IBOutlet NSScrollView *scrollView;
@property (assign) IBOutlet NSClipView *clipView;
@property (assign) IBOutlet NSTextField *stringField;
@property (retain) IBOutlet NSPanel *textInputPanel;
@property (assign) BOOL showWindow;
@property (retain) TMMTTextLayer *textLayer;
@property (retain) CATextLayer *regularTextLayer;
@property (copy) NSString *zoomString;

@end

@implementation AppDelegate

-(void)dealloc
{
	[_textInputPanel release];
	[_textLayer release];
	[_zoomString release];
	[super dealloc];
	
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	[self.scrollView addObserver:self forKeyPath:@"magnification" options:NSKeyValueObservingOptionNew context:nil];
	
	self.showWindow = NO;
		[self.scrollView setWantsLayer:YES];

	[self.clipView setWantsLayer:YES];
	[self.layerView setWantsLayer:YES];
	self.layerView.layer.layoutManager = [CAConstraintLayoutManager layoutManager];
	[self.layerView.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
	
	TMMTTextLayer *newTextLayer = [TMMTTextLayer layer];
	self.textLayer = newTextLayer;
	[newTextLayer setBackgroundColor:[[NSColor whiteColor] CGColor]];
	[newTextLayer setDelegate:newTextLayer];
	[newTextLayer setFrame:NSMakeRect(10, 50, 160, 30)];
	[newTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
	[newTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY offset:-20]];
	[newTextLayer setParagraphAlignment:NSCenterTextAlignment];
	[newTextLayer setActions:@{@"contentsScale":[NSNull null], @"position":[NSNull null], @"contents":[NSNull null]}];
	[newTextLayer setBorderWidth:0];
	[self.layerView setFrame:self.layerView.superview.bounds];
	[[self.layerView layer] addSublayer:newTextLayer];
	newTextLayer.textFont = [NSFont systemFontOfSize:16];//[NSFont fontWithName:@"Helvetica Neue" size:16];
	[newTextLayer setString:@"TMMTTextLayer"];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidSmartZoom) name:NSScrollViewDidEndLiveMagnifyNotification object:nil];
	
	CATextLayer *regularTextLayer = [CATextLayer layer];
	[regularTextLayer setBackgroundColor:[[NSColor whiteColor] CGColor]];
	[regularTextLayer setForegroundColor:[[NSColor blackColor] CGColor]];
	[regularTextLayer setDelegate:regularTextLayer];
	[regularTextLayer setFrame:NSMakeRect(10,80, 160, 30)];
	[regularTextLayer setAlignmentMode:kCAAlignmentCenter];
	[regularTextLayer setFont:(CTFontRef)[NSFont systemFontOfSize:12]];
	[regularTextLayer setFontSize:16];
	[regularTextLayer setBorderWidth:0];
	[regularTextLayer setActions:@{@"contentsScale":[NSNull null], @"position":[NSNull null], @"contents":[NSNull null]}];
	[regularTextLayer setString:@"CATextLayer"];
	[regularTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
	[regularTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY offset:20]];
	[self.layerView.layer addSublayer:regularTextLayer];
	[regularTextLayer setNeedsDisplay];
	self.regularTextLayer = regularTextLayer;
	
	
	
	self.scrollView.magnification = 1.0;
	self.zoomString = [NSString stringWithFormat:@"Zoom: %2.02f",self.scrollView.magnification];



}

-(void)scrollViewDidSmartZoom
{
	
	CGFloat scale = [self.scrollView magnification];
//
//	scale = roundf(scale);
//	
//	self.scrollView.magnification = scale;
	self.regularTextLayer.contentsScale = [[NSScreen mainScreen] backingScaleFactor] * scale;

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	
	if ([keyPath isEqualToString:@"magnification"])
	{
		self.zoomString = [NSString stringWithFormat:@"Zoom: %2.02f",self.scrollView.magnification];
		
		if (self.scrollView.magnification > 1)
		{
			[[self.scrollView horizontalScroller] setHidden:NO];
			[[self.scrollView verticalScroller] setHidden:NO];
			
		}
		else
		{
			[[self.scrollView horizontalScroller] setHidden:YES];
			[[self.scrollView verticalScroller] setHidden:YES];
			if (self.scrollView.magnification == 1)
				[self.layerView setFrame:self.scrollView.contentView.bounds];
		}
		
		//If they have zooming magnification enabled...
//		self.regularTextLayer.contentsScale = [[NSScreen mainScreen] backingScaleFactor] * self.scrollView.magnification;
		
	}
	else
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	
}

-(void)windowDidResize:(NSNotification *)notification
{
	
//	self.layerView.frame = self.scrollView.contentView.bounds;
	
}

-(void)windowWillClose:(NSNotification *)notification
{

	[NSApp terminate:self];
	
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}



- (IBAction)updateLayerText:(id)sender
{
	
	NSString *stringToSend = [self.stringField stringValue];
	[self.textLayer setString:stringToSend];
	
}


@end
