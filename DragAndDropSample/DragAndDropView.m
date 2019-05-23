//
//  DragAndDropView.m
//  DragAndDropSample
//
//  Created by HIROKI IKEUCHI on 2019/05/23.
//  Copyright © 2019年 hikeuchi. All rights reserved.
//

#import "DragAndDropView.h"

@interface DragAndDropView ()
@property (nonatomic) BOOL highlight;   // View上にファイルがドラッグされているならば、ハイライトをつける
@end

@implementation DragAndDropView

/**
 @brief IB上でオブジェクトが生成される際に呼ばれる
 */
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self setHighlight:NO];
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    }
    return self;
}

/**
 @brief Viewの描画処理
        View上にファイルがドラッグされているならば、ハイライトをつける
 */
- (void)drawRect:(NSRect)rect{
    [super drawRect:rect];
    if (_highlight) {
        [[NSColor systemBlueColor] set];
        [NSBezierPath setDefaultLineWidth: 5];
        [NSBezierPath strokeRect: [self bounds]];
    } else {
        [[NSColor grayColor] set];
        [NSBezierPath setDefaultLineWidth: 1];
        [NSBezierPath strokeRect: [self bounds]];
    }
}

/**
 @brief ドラッグしたファイルが目的の境界内に入ると呼ばれる
 画像が送り先の境界にドラッグされると、送り先にdraggingEntered:メッセージが送信されます。このメソッドは、宛先がどのドラッグ操作を実行するのかを示す値を返す必要があります。
 */
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender{
    _highlight=YES;
    [self setNeedsDisplay: YES];
    return NSDragOperationGeneric;
}


/**
 @brief 画像が宛先内にある間、一連のdraggingUpdated:メッセージが送信されます。このメソッドは、宛先がどのドラッグ操作を実行するのかを示す値を返す必要があります。
 */
- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender{
    _highlight=YES;
    [self setNeedsDisplay: YES];
    return NSDragOperationGeneric;
}

/**
 @brief レシーバからドラッグが外れた時に呼び出されます
 画像が送り先からドラッグさdraggingExited:れると、が送信され、一連のNSDraggingDestinationメッセージが停止します。再入力すると、シーケンスは（新しいdraggingEntered:メッセージとともに）再び始まります。
 */
- (void)draggingExited:(id <NSDraggingInfo>)sender{
    _highlight=NO;
    [self setNeedsDisplay: YES];
}


/**
 @brief ドラッグしたファイルがリリースされたときに呼ばれる
 イメージが解放さprepareForDragOperation:れると、draggingEntered:またはの最後の呼び出しによって返された値に応じて、イメージがそのソースにスライドバックする（そしてシーケンスを中断する）か、メッセージがデスティネーションに送信されますdraggingUpdated:。
 prepareForDragOperation:メッセージが返された場合はYES、performDragOperation:メッセージが送信されます。
 */
- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    _highlight=NO;
    [self setNeedsDisplay: YES];
    return YES;
}


/**
 @brief ドラッグしたファイルがリリースされた後に呼ばれる
 Finally, if performDragOperation: returned YES, concludeDragOperation: is sent.
 */
- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
    NSArray *draggedFilenames = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    //    if ([[[draggedFilenames objectAtIndex:0] pathExtension] isEqual:@"txt"]){
    //        return YES;
    //    } else {
    //        return NO;
    //    }
    for (NSString *draggedFilename in draggedFilenames) {
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:draggedFilename isDirectory:&isDir] == NO) {
            return NO;
        }
        if (isDir == YES) {
            return NO;      // フォルダがあったら以降の処理をしない
        }
    }
    return YES;
}

/**
 @brief ドラッグ操作が完了したときに呼び出されます
 */
- (void)concludeDragOperation:(id <NSDraggingInfo>)sender{
    NSArray *draggedFilenames = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    //    NSString *textDataFile = [NSString stringWithContentsOfFile:[draggedFilenames objectAtIndex:0] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@", draggedFilenames.description);
}
@end
