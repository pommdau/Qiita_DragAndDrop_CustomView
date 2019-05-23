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

// MARK:- NSDraggingDestination Protocol Methods

/**
 @brief Viewの境界にファイルがドラッグされるときに呼ばれる
        宛先がどのドラッグ操作を実行するのかを示す値を返す必要があります。
 */
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender{
    [self setHighlight:YES];
    [self setNeedsDisplay: YES];    // ハイライトの情報が変更された場合に再描画を行う
    return NSDragOperationGeneric;
}


/**
 @brief View上にファイルがドラッグで保持されている間、短い間隔毎に呼ばれるメソッド
 宛先がどのドラッグ操作を実行するのかを示す値を返す必要があります。
 */
- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender{
    [self setHighlight:YES];
    [self setNeedsDisplay: YES];
    return NSDragOperationGeneric;
}

/**
 @brief View上にファイルがドラッグされなくなった際に呼ばれる
 */
- (void)draggingExited:(id <NSDraggingInfo>)sender{
    [self setHighlight:NO];
    [self setNeedsDisplay: YES];
}


/**
 @brief View上でファイルがドロップされた際に呼ばれる
 メッセージが返された場合はYES、performDragOperation:メッセージが送信されます。
 */
- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    [self setHighlight:NO];
    [self setNeedsDisplay: YES];
    return YES;
}


/**
 @brief View上でファイルがドロップされた後の処理
 */
- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
    NSArray *draggedFilenames = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    /*  // 対応していないファイルがドロップした場合の処理の例
    if ([[[draggedFilenames objectAtIndex:0] pathExtension] isEqual:@"txt"]){
        return YES; // テキストファイルのみ対象とする
    } else {
        return NO;
    }
     */
    for (NSString *draggedFilename in draggedFilenames) {
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:draggedFilename isDirectory:&isDir] == NO) {
            return NO;
        }
        if (isDir == YES) {
            return NO;      // フォルダがあった場合はエラーとする
        }
    }
    return YES;
}

/**
 @brief 一連のドラッグ操作が完了したときに呼ばれる
 */
- (void)concludeDragOperation:(id <NSDraggingInfo>)sender{
    NSArray *filePaths = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    [_delegate DragAndDropViewGetDraggingFiles:filePaths];
}
@end
