//
//  AppDelegate.h
//  Syntax
//
//  Created by Neil Singh on 3/7/15.
//  Copyright (c) 2015 Neil Singh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	IBOutlet NSTextView* inputView;
	IBOutlet NSTextView* outputView;
}

@end

