//
//  AppDelegate.m
//  BootTask
//
//  Created by PC on 2021/8/16.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()<NSWindowDelegate>

@property(nonatomic, strong) NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

    [self setupUI];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}




- (void)setupUI
{
    NSRect rect = CGRectMake(0, 0, 320, 120);
    self.window = [[NSWindow alloc] initWithContentRect:rect styleMask:NSWindowStyleMaskMiniaturizable|NSWindowStyleMaskClosable|NSWindowStyleMaskResizable backing:NSBackingStoreBuffered defer:NO];
    self.window.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
    self.window.delegate = self;
    [self.window makeKeyWindow];


    ViewController *vc = [[ViewController alloc] init];
    self.window.contentViewController = vc;

    [NSApp beginModalSessionForWindow:self.window];
}

@end
