//
//  SCKey.m
//  SCKeyRecorder
//
//  Created by David Keegan on 11/21/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import "SCKey.h"
#import <Carbon/Carbon.h>

@implementation SCKey{
    NSString *_stringValue;
    NSString *_prettyStringValue;
    unsigned short _keyCode;
}

+ (SCKey *)key{
    return [[[[self class] alloc] init] arc_autorelease];
}

+ (SCKey *)keyFromString:(NSString *)string{
    string = [string lowercaseString];
    if([string isEqualToString:@"ctl"] ||
       [string isEqualToString:@"ctrl"] ||
       [string isEqualToString:@"control"]){
        return [SCKeyControl key];
    }else if([string isEqualToString:@"cmd"] ||
       [string isEqualToString:@"command"]){
        return [SCKeyCommand key];
    }else if([string isEqualToString:@"opt"] ||
            [string isEqualToString:@"option"]){
        return [SCKeyOption key];
    }else if([string isEqualToString:@"shift"]){
        return [SCKeyShift key];
    }else if([string isEqualToString:@"up"]){
        return [SCKeyUp key];
    }else if([string isEqualToString:@"down"]){
        return [SCKeyDown key];
    }else if([string isEqualToString:@"left"]){
        return [SCKeyLeft key];
    }else if([string isEqualToString:@"right"]){
        return [SCKeyRight key];
    }
    return [[[[self class] alloc] initWithString:string] arc_autorelease];
}

- (id)initWithString:(NSString *)string{
    if ((self = [super init])) {
        _stringValue = [string copy];
        _prettyStringValue = [[_stringValue capitalizedString] arc_retain];
    }
    return self;
}

- (id)initWithCode:(unsigned short)code{
    if ((self = [super init])) {
        _keyCode = code;
    }
    return self;
}

+ (SCKey *)keyFromCode:(unsigned short)code{
    if (code == kVK_Control || code == kVK_RightControl) {
        return [SCKeyControl key];
    } else if (code == kVK_Command) {
        return [SCKeyCommand key];
    } else if (code == kVK_Option || code == kVK_RightOption) {
        return [SCKeyOption key];
    } else if (code == kVK_Shift || code == kVK_RightShift) {
        return [SCKeyShift key];
    } else if (code == kVK_UpArrow) {
        return [SCKeyUp key];
    } else if (code == kVK_DownArrow) {
        return [SCKeyDown key];
    } else if (code == kVK_LeftArrow) {
        return [SCKeyLeft key];
    } else if (code == kVK_RightArrow) {
        return [SCKeyRight key];
    }
    return [[[[self class] alloc] initWithCode:code] arc_autorelease];
}

- (BOOL)isModifierKey{
    return NO;
}

- (NSString *)stringValue{
    return _stringValue ?: @"";
}

- (NSString *)prettyStringValue{
    return _prettyStringValue ?: @"";
}

- (unsigned short)keyCode{
    return _keyCode;
}

- (NSDictionary *)textAttributes{
    static NSDictionary *_textAttributes = nil;
    if(_textAttributes == nil){
        NSShadow *textShadow = [[NSShadow alloc] init];
        [textShadow setShadowOffset:NSMakeSize(0.0f, -1.0f)];
        [textShadow setShadowColor:[NSColor colorWithDeviceWhite:1.0f alpha:0.6f]];
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        [attributes setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
        [attributes setObject:[NSFont systemFontOfSize:11.0f] forKey:NSFontAttributeName];
        [attributes setObject:textShadow forKey:NSShadowAttributeName];
        _textAttributes = [[NSDictionary dictionaryWithDictionary:attributes] arc_retain];
        [attributes arc_release];
        [textShadow arc_release];
    }
    return _textAttributes;
}

- (NSDictionary *)largeTextAttributes{
    static NSDictionary *_largeTextAttributes = nil;
    if(_largeTextAttributes == nil){
        NSShadow *textShadow = [[NSShadow alloc] init];
        [textShadow setShadowOffset:NSMakeSize(0.0f, -1.0f)];
        [textShadow setShadowColor:[NSColor colorWithDeviceWhite:1.0f alpha:0.6f]];
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        [attributes setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
        [attributes setObject:[NSFont systemFontOfSize:13.0f] forKey:NSFontAttributeName];
        [attributes setObject:textShadow forKey:NSShadowAttributeName];
        _largeTextAttributes = [[NSDictionary dictionaryWithDictionary:attributes] arc_retain];
        [attributes arc_release];
        [textShadow arc_release];
    }
    return _largeTextAttributes;
}

- (void)drawKeyInRect:(NSRect)rect{
    NSString *keyString = [self prettyStringValue];
    NSRect textRect = rect;
    textRect.size = [keyString sizeWithAttributes:[self largeTextAttributes]];
    textRect.origin.y += 10.0f;
    textRect.origin.x += rect.size.width*0.5-textRect.size.width*0.5;
    NSAttributedString *attributedString = 
    [[NSAttributedString alloc] initWithString:keyString attributes:[self largeTextAttributes]];
    [attributedString drawInRect:textRect];
    [attributedString arc_release];
}

- (void)dealloc{
    [_stringValue arc_release];
    [_prettyStringValue arc_release];
    ARCSuperDealloc;
}

@end


@implementation SCModifierKey
- (BOOL)isModifierKey{
    return YES;
}
- (void)drawKeyInRect:(NSRect)rect{
    NSString *keyString = [self prettyStringValue];
    rect.size = [keyString sizeWithAttributes:[self textAttributes]];
    rect.origin.y += 3.0f;
    rect.origin.x += 6.0f;
    NSAttributedString *attributedString = 
    [[NSAttributedString alloc] initWithString:keyString attributes:[self textAttributes]];
    [attributedString drawInRect:rect];
    [attributedString arc_release];
}
- (NSUInteger)modifierFlag{
    return 0;
}
@end


@implementation SCKeyCommand
- (NSString *)stringValue{
    return @"cmd";
}
- (NSString *)prettyStringValue{
    return @"command";
}
- (void)drawKeyInRect:(NSRect)rect{
    [super drawKeyInRect:rect];
    NSString *cmdString = @"⌘";
    NSRect textRect = rect;
    textRect.size = [cmdString sizeWithAttributes:[self largeTextAttributes]];
    textRect.origin.y += rect.size.height-textRect.size.height-3.0f;
    textRect.origin.x += rect.size.width-textRect.size.width-5.0f;
    NSAttributedString *attributedString = 
    [[NSAttributedString alloc] initWithString:cmdString attributes:[self largeTextAttributes]];
    [attributedString drawInRect:textRect];
    [attributedString arc_release];    
}
- (NSUInteger)modifierFlag{
    return NSShiftKeyMask;
}
@end

@implementation SCKeyControl
- (NSString *)stringValue{
    return @"ctrl";
}
- (NSString *)prettyStringValue{
    return @"control";
}
- (NSUInteger)modifierFlag{
    return NSControlKeyMask;
}
@end

@implementation SCKeyOption
- (NSString *)stringValue{
    return @"opt";
}
- (NSString *)prettyStringValue{
    return @"option";
}
- (void)drawKeyInRect:(NSRect)rect{
    [super drawKeyInRect:rect];
    NSString *cmdString = @"alt";
    NSRect textRect = rect;
    textRect.size = [cmdString sizeWithAttributes:[self textAttributes]];
    textRect.origin.y += rect.size.height-textRect.size.height-3.0f;
    textRect.origin.x += 5.0f;
    NSAttributedString *attributedString = 
    [[NSAttributedString alloc] initWithString:cmdString attributes:[self textAttributes]];
    [attributedString drawInRect:textRect];
    [attributedString arc_release];
}
- (NSUInteger)modifierFlag{
    return NSAlternateKeyMask;
}
@end

@implementation SCKeyShift
- (NSString *)stringValue{
    return @"shift";
}
- (NSString *)prettyStringValue{
    return [self stringValue];
}
- (NSUInteger)modifierFlag
{
    return NSShiftKeyMask;
}
@end


@implementation SCKeyUp
- (NSString *)stringValue{
    return @"up";
}
- (NSString *)prettyStringValue{
    return @"▲";
}
@end

@implementation SCKeyDown
- (NSString *)stringValue{
    return @"down";
}
- (NSString *)prettyStringValue{
    return @"▼";
}
@end

@implementation SCKeyLeft
- (NSString *)stringValue{
    return @"left";
}
- (NSString *)prettyStringValue{
    return @"◀";
}
@end

@implementation SCKeyRight
- (NSString *)stringValue{
    return @"right";
}
- (NSString *)prettyStringValue{
    return @"▶";
}
@end
