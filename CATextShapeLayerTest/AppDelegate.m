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
#import "TMMTTextShapeLayer.h"

@interface AppDelegate ()

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *layerView;
@property (assign) IBOutlet NSScrollView *scrollView;
@property (assign) IBOutlet NSClipView *clipView;
@property (assign) IBOutlet NSTextField *stringField;
@property (retain) IBOutlet NSPanel *textInputPanel;
@property (assign) BOOL showWindow;
@property (retain) TMMTTextShapeLayer *textLayer;
@end

@implementation AppDelegate



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	self.showWindow = NO;
	TMMTTextShapeLayer *newTextLayer = [TMMTTextShapeLayer layer];
	self.textLayer = newTextLayer;
	[self.scrollView setWantsLayer:YES];
	[self.clipView setWantsLayer:YES];
	
	[self.layerView setWantsLayer:YES];
	[newTextLayer setBackgroundColor:[[NSColor whiteColor] CGColor]];
	[newTextLayer setDelegate:newTextLayer];
	[newTextLayer setFrame:NSMakeRect(10, 50, 640, 480)];
	
	[self.layerView setFrame:self.layerView.superview.bounds];
	[[self.layerView layer] addSublayer:newTextLayer];
	newTextLayer.textFont = [NSFont systemFontOfSize:16];//[NSFont fontWithName:@"Helvetica Neue" size:16];
	[newTextLayer setString:@"2"];
	

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
