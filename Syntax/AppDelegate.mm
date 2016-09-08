//
//  AppDelegate.m
//  Syntax
//
//  Created by Neil Singh on 3/7/15.
//  Copyright (c) 2015 Neil Singh. All rights reserved.
//

#import "AppDelegate.h"
#import <vector>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	[ inputView setDelegate:(id<NSTextViewDelegate>)self ];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

const char posschar[] = { ' ', '\n', '\t', '`', '!', '#', '$', '%', '^', '&', '*', '(', ')', '-', '+', '=', '[', '{', '}', ']', '\\', '|', ',', '<', '>', '.', '?', '/', ';', ':', };
void ApplyHighlights(NSArray* ctypes, NSMutableString* inputString, NSMutableAttributedString* string,unsigned long numTypes, NSRange range, NSColor* color)
{
	for (unsigned long z = 0; z < numTypes; z++)
	{
		NSRange search = NSMakeRange(0, 0);
		do
		{
			search = [ inputString rangeOfString:[ ctypes objectAtIndex:z ] options:0 range:NSMakeRange(NSMaxRange(search), NSMaxRange(range) - NSMaxRange(search)) ];
			if (search.length == 0)
				break;
			if (search.location != 0)
			{
				BOOL doesContain = FALSE;
				unsigned char cmd = [ inputString characterAtIndex:search.location - 1 ];
				for (int q = 0; q < sizeof(posschar) / sizeof(char); q++)
				{
					if (cmd == posschar[q])
					{
						doesContain = TRUE;
						break;
					}
				}
				if (!doesContain)
					continue;
			}
			if (NSMaxRange(search) < [ inputString length ])
			{
				if (([ inputString characterAtIndex:NSMaxRange(search) ] >= '0' && [ inputString characterAtIndex:NSMaxRange(search) ] <= '9') || ([ inputString characterAtIndex:NSMaxRange(search) ] >= 'a' && [ inputString characterAtIndex:NSMaxRange(search) ] <= 'z') || ([ inputString characterAtIndex:NSMaxRange(search) ] >= 'A' && [ inputString characterAtIndex:NSMaxRange(search) ] <= 'Z'))
					continue;
			}
			[ string addAttribute:NSForegroundColorAttributeName value:color range:search ];
		}
		while (search.length != 0);
	}
}

- (void) textDidChange:(id)sender
{
	NSMutableString* inputString = [ NSMutableString stringWithString:[ [ inputView textStorage ] string ] ];
	//[ inputString replaceOccurrencesOfString:@"  " withString:@"\t" options:0 range:NSMakeRange(0, inputString.length) ];
	NSMutableAttributedString* string = [ [ NSMutableAttributedString alloc ] initWithString:inputString attributes:[ NSDictionary dictionaryWithObjectsAndKeys:[ NSFont fontWithName:@"Menlo" size:11 ], NSFontAttributeName, nil ] ];
	
	NSRange range = NSMakeRange(0, [ inputString length ]);
	
	NSArray* ctypes = @[ @"unsigned", @"signed", @"char", @"short", @"int", @"long", @"const", @"void", @"float", @"double", @"BOOL", @"bool", @"if", @"for", @"while", @"do", @"self", @"id", @"IMP", @"@implementation", @"@end", @"@interface", @"return", @"@synthesize", @"@property", @"@protocol", @"@selector", @"@encode", @"@try", @"@catch", @"@finally", @"@throw", @"@dynamic", @"YES", @"NO", @"TRUE", @"true", @"FALSE", @"false", @"NULL", @"nil", @"Nil", @"break", @"switch", @"case", @"try", @"catch", @"throw", @"and", @"and_eq", @"asm", @"auto", @"bitand", @"bitor", @"class", @"compl", @"const_cast", @"continue", @"default", @"delete", @"dynamic_cast", @"else", @"enum", @"explicit", @"extern", @"friend", @"goto", @"inline", @"mutable", @"namespace", @"new", @"not", @"not_eq", @"operator", @"or", @"or_eq", @"private", @"protected", @"public", @"register", @"reinterpret_cast", @"sizeof", @"static", @"static_cast", @"struct", @"template", @"this", @"typedef", @"typeid", @"typename",  @"union", @"using", @"virtual", @"volatile", @"wchar_t", @"xor", @"xor_eq", @"@private", @"@protected", @"@public", @"@synchronized", @"byref", @"oneway", @"super", @"in", @"out", ];
	ApplyHighlights(ctypes, inputString, string, [ ctypes count ], range, [ NSColor colorWithCalibratedRed:0.712569 green:0.2 blue:0.631373 alpha:1 ]);
	NSArray* etypes = @[ @"digitalWrite", @"analogWrite", @"digitalRead", @"analogRead", @"tone", @"notone", @"delay", @"pinMode", @"setup", @"loop", @"map", @"constrain", @"Serial", @"print", @"println", @"begin", @"available", @"parseInt" ];
	ApplyHighlights(etypes, inputString, string, [ etypes count ], range, [ NSColor colorWithCalibratedRed:1.000000 green:0.558549 blue:0.052716 alpha:1 ]);
	NSArray* btypes = @[ @"HIGH", @"LOW", @"OUTPUT", @"INPUT", @"PI", ];
	ApplyHighlights(btypes, inputString, string, [ btypes count ], range, [ NSColor colorWithCalibratedRed:0.0 green:0.3 blue:1.0 alpha:1 ]);
	
	// Numbers
	for (int z = 0; z < 10; z++)
	{
		NSRange search = NSMakeRange(0, 0);
		do
		{
			search = [ inputString rangeOfString:[ NSString stringWithFormat:@"%i", z ] options:0 range:NSMakeRange(NSMaxRange(search), NSMaxRange(range) - NSMaxRange(search)) ];
			if (search.length == 0)
				break;
			// Check previous stuff
			BOOL allClear = FALSE;
			for (unsigned long long index = search.location - 1; index != -1; index--)
			{
				if (([ inputString characterAtIndex:index ] >= 'a' && [ inputString characterAtIndex:index ] <= 'z') || ([ inputString characterAtIndex:index ] >= 'A' && [ inputString characterAtIndex:index ] <= 'Z') || [ inputString characterAtIndex:index ] == '~' || [ inputString characterAtIndex:index ] == '_')
				{
					if ([ inputString characterAtIndex:index ] == 'f' || [ inputString characterAtIndex:index ] == 'F' || [ inputString characterAtIndex:index ] == 'l')
						continue;
					break;
				}
				char cmd = [ inputString characterAtIndex:index ];
				for (int q = 0; q < sizeof(posschar) / sizeof(char); q++)
				{
					if (cmd == posschar[q])
					{
						allClear = TRUE;
						break;
					}
				}
				if (allClear)
					break;
			}
			if (!allClear)
				continue;
			if (NSMaxRange(search) < [ inputString length ] && ([ inputString characterAtIndex:NSMaxRange(search) ] == 'f' || [ inputString characterAtIndex:NSMaxRange(search) ] == 'l'))
				search.length++;
			[ string addAttribute:NSForegroundColorAttributeName value:[ NSColor colorWithCalibratedRed:0.160784 green:0.203922 blue:0.870588 alpha:1 ] range:search ];
		}
		while (search.length != 0);
	}
	
	// Comments
	std::vector<NSRange> commentRanges;
	do
	{
		NSRange commentRange = [ inputString rangeOfString:@"//" options:0 range:range ];
		if (commentRange.length != 0)
		{
			range = NSMakeRange(NSMaxRange(commentRange), [ inputString length ] - NSMaxRange(commentRange));
			NSRange commentEndRange = [ inputString rangeOfString:@"\n" options:0 range:range ];
			if (commentEndRange.length == 0)
				commentEndRange.location = [ inputString length ];
			
			[ string removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(commentRange.location, NSMaxRange(commentEndRange) - commentRange.location) ];
			[ string addAttribute:NSForegroundColorAttributeName value:[ NSColor colorWithCalibratedRed:0 green:116.0/255 blue:0 alpha:1] range:NSMakeRange(commentRange.location, NSMaxRange(commentEndRange) - commentRange.location) ];
			commentRanges.push_back(NSMakeRange(commentRange.location, NSMaxRange(commentEndRange) - commentRange.location));
			if (NSMaxRange(commentEndRange) >= [ inputString length ])
				break;
			range = NSMakeRange(NSMaxRange(commentEndRange), [ inputString length ] - NSMaxRange(commentEndRange));
		}
		else
			break;
	}
	while (range.length != 0);
	
	range = NSMakeRange(0, [ inputString length ]);
	do
	{
		NSRange commentRange = [ inputString rangeOfString:@"/*" options:0 range:range ];
		if (commentRange.length != 0)
		{
			range = NSMakeRange(NSMaxRange(commentRange), [ inputString length ] - NSMaxRange(commentRange));
			NSRange commentEndRange = [ inputString rangeOfString:@"*/" options:0 range:range ];
			if (commentEndRange.length == 0)
				commentEndRange.location = [ inputString length ];
			
			[ string removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(commentRange.location, NSMaxRange(commentEndRange) - commentRange.location) ];
			[ string addAttribute:NSForegroundColorAttributeName value:[ NSColor colorWithCalibratedRed:0 green:116.0/255 blue:0 alpha:1] range:NSMakeRange(commentRange.location, NSMaxRange(commentEndRange) - commentRange.location) ];
			commentRanges.push_back(NSMakeRange(commentRange.location, NSMaxRange(commentEndRange) - commentRange.location));
			if (NSMaxRange(commentEndRange) >= [ inputString length ])
				break;
			range = NSMakeRange(NSMaxRange(commentEndRange), [ inputString length ] - NSMaxRange(commentEndRange));
		}
		else
			break;
	}
	while (range.length != 0);
	
	// Strings
	NSRange search = NSMakeRange(range.location, 1);
	int fullString = 1;
	do
	{
		if (fullString)
			search = [ inputString rangeOfString:@"\"" options:0 range:NSMakeRange(NSMaxRange(search), NSMaxRange(range) - NSMaxRange(search)) ];
		else
			search = [ inputString rangeOfString:@"'" options:0 range:NSMakeRange(NSMaxRange(search), NSMaxRange(range) - NSMaxRange(search)) ];
		if (search.length == 0)
		{
			if (!fullString)
				break;
			search = NSMakeRange(range.location, 1);
			fullString = !fullString;
			continue;
		}
		// If its in a comment, ignore it
		BOOL shouldContinue = FALSE;
		for (int z = 0; z < commentRanges.size(); z++)
		{
			if (search.location >= commentRanges[z].location && NSMaxRange(search) <= NSMaxRange(commentRanges[z]))
			{
				shouldContinue = TRUE;
				break;
			}
		}
		if (shouldContinue)
			continue;
		
		// Find next "
		unsigned long long end = NSMaxRange(search);
		while (end < NSMaxRange(range))
		{
			if (([ inputString characterAtIndex:end ] == '"' && fullString) || ([ inputString characterAtIndex:end ] == '\'' && !fullString))
			{
				end++;
				break;
			}
			if ([ inputString characterAtIndex:end ] == '\\')
				end++;
			end++;
		}
		if ([ inputString characterAtIndex:search.location - 1 ] == '@')
			search.location--;
		if (fullString)
		{
			[ string removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(search.location, end - search.location) ];
			[ string addAttribute:NSForegroundColorAttributeName value:[ NSColor colorWithCalibratedRed:0.878431 green:0.313726 blue:0.384314 alpha:1 ] range:NSMakeRange(search.location, end - search.location) ];
		}
		else
		{
			[ string removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(search.location, end - search.location) ];
			[ string addAttribute:NSForegroundColorAttributeName value:[ NSColor colorWithCalibratedRed:0.160784 green:0.203922 blue:0.870588 alpha:1 ] range:NSMakeRange(search.location, end - search.location) ];
		}
		search.location = end - 1;
		
		if (end == NSMaxRange(range))
		{
			if (!fullString)
				break;
			search = NSMakeRange(range.location, 1);
			fullString = !fullString;
			continue;
		}
		if (search.length == 0)
		{
			if (!fullString)
				break;
			search = NSMakeRange(range.location, 1);
			fullString = !fullString;
			continue;
		}
	}
	while (search.length != 0);
	
	[ [ outputView textStorage ] setAttributedString:string ];
}


- (IBAction) save:(id)sender
{
	NSSavePanel* panel = [ [ NSSavePanel alloc ] init ];
	[ panel setAllowedFileTypes:@[ @"ino" ] ];
	if ([ panel runModal ])
	{
		NSString* string = [ [ outputView textStorage ] string ];
		NSString* directory = [ NSString stringWithFormat:@"%@/%@", [ [ panel filename ] stringByDeletingLastPathComponent ], [ [ [ panel filename ] lastPathComponent ] stringByDeletingPathExtension ] ];
		[ [ NSFileManager defaultManager ] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil ];
		[ [ NSFileManager defaultManager ] createFileAtPath:[ NSString stringWithFormat:@"%@/%@", directory, [ [ panel filename ] lastPathComponent ] ] contents:[ [ NSData alloc ] initWithBytes:[ string UTF8String ] length:[ string length ] ] attributes:nil ];
	}
}

@end
