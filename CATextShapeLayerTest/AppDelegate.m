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

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *layerView;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSClipView *clipView;
@property (weak) IBOutlet NSTextField *stringField;
@property (strong) IBOutlet NSPanel *textInputPanel;
@property (assign) BOOL showWindow;
@property (strong) TMMTTextShapeLayer *textLayer;
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
	[newTextLayer setBackgroundColor:[[NSColor darkGrayColor] CGColor]];
	[newTextLayer setDelegate:newTextLayer];
	[newTextLayer setFrame:NSMakeRect(10, 50, 640, 480)];
	
	[self.layerView setFrame:self.layerView.superview.bounds];
	[[self.layerView layer] addSublayer:newTextLayer];
	newTextLayer.textFont = [NSFont fontWithName:@"Calibri Italic" size:32];
	[newTextLayer setString:@"Testing fluecy\nTesting difference!\nWill's fjord is finished!"];
	

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
