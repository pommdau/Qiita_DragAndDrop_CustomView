//
//  AppDelegate.m
//  DragAndDropSample
//
//  Created by HIROKI IKEUCHI on 2019/05/23.
//  Copyright © 2019年 hikeuchi. All rights reserved.
//

#import "AppDelegate.h"
#import "DragAndDropView.h"

@interface AppDelegate () <DragAndDropViewDelegate>
@property (weak) IBOutlet DragAndDropView *dragAndDropView;
@property (weak) IBOutlet NSTextField *resultTextField;

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    _dragAndDropView.delegate = self;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

// MARK;- DragAndDropViewDelegate  Methods
- (void)DragAndDropViewGetDraggingFiles:(NSArray *)files {
    NSMutableString *resultMessage = [NSMutableString string];
    for (NSString *file in files) {
        [resultMessage appendFormat:@"%@\r\n", file];
    }
    [_resultTextField setStringValue:resultMessage];
}

// MARK:- Button Action
- (IBAction)clear:(id)sender {
    [_resultTextField setStringValue:@""];
}


@end
