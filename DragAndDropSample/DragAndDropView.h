//
//  DragAndDropView.h
//  DragAndDropSample
//
//  Created by HIROKI IKEUCHI on 2019/05/23.
//  Copyright © 2019年 hikeuchi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol DragAndDropViewDelegate <NSObject>
- (void)DragAndDropViewGetDraggingFiles:(NSArray *)files;  // ビュー上にファイルがD&Dされた場合に呼ばれる
@end

@interface DragAndDropView : NSView
@property (weak, nonatomic) id <DragAndDropViewDelegate> delegate;
@end

