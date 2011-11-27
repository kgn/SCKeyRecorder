//
//  SCKeyView.m
//  SCKeyRecorder
//
//  Created by David Keegan on 11/21/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SCKeyView.h"
#import "NSObject+ARC.h"

#define SCOUTER_BORDER_COLOR [NSColor colorWithDeviceWhite:0.369f alpha:1.0f]
#define SCOUTER_TOP_GRADIENT_COLOR [NSColor colorWithDeviceWhite:0.765f alpha:1.0f]
#define SCOUTER_BOTTOM_GRADIENT_COLOR [NSColor colorWithDeviceWhite:0.882f alpha:1.0f]

#define SCOUTER_TOP_SHADOW_DISTANCE 5.0f
#define SCOUTER_TOP_SHADOW_COLOR [NSColor colorWithDeviceWhite:0.0f alpha:0.25f]
#define SCOUTER_BOTTOM_SHADOW_COLOR [NSColor colorWithDeviceWhite:0.0f alpha:0.15f]

#define SCKEY_BORDER_COLOR [NSColor colorWithDeviceWhite:0.412f alpha:1.0f]
#define SCKEY_HIGHLIGHT_COLOR [NSColor colorWithDeviceWhite:0.980f alpha:1.0f]
#define SCKEY_INNER_GLOW_COLOR [NSColor colorWithDeviceWhite:0.945f alpha:1.0f]
#define SCKEY_TOP_GRADIENT_COLOR [NSColor colorWithDeviceWhite:0.918f alpha:1.0f]
#define SCKEY_BOTTOM_GRADIENT_COLOR [NSColor colorWithDeviceWhite:0.914f alpha:1.0f]
#define SCKEY_UNDER_COLOR [NSColor colorWithDeviceWhite:0.659f alpha:1.0f]

static CGImageRef createNoiseImageRef(int width, int height, float factor){
    int size = width*height;
    char *rgba = (char *)malloc(size); srand(124);
    for(int i=0; i < size; ++i){rgba[i] = rand()%256*factor;}
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapContext = 
    CGBitmapContextCreate(rgba, width, height, 8, width, colorSpace, kCGImageAlphaNone);
    CFRelease(colorSpace);
    free(rgba);
    CGImageRef image = CGBitmapContextCreateImage(bitmapContext);
    CFRelease(bitmapContext);
    return image;
}

@implementation SCKeyView{
    NSArray *_keys;
}

- (id)initWithFrame:(NSRect)frame{
    if((self = [super initWithFrame:frame])){
        _keys = [[NSArray alloc] init];
    }
    return self;
}

- (NSString *)keysString{
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:[_keys count]];
    for(SCKey *key in _keys){
        [keys addObject:[key stringValue]];
    }
    return [keys componentsJoinedByString:@"+"];
}

- (void)setKeysWithString:(NSString *)keys{
    [self setKeysWithArray:[keys componentsSeparatedByString:@"+"]];
}

- (void)setKeysWithArray:(NSArray *)keys{
    NSMutableArray *mkeys = [[NSMutableArray alloc] init];
    for(id key in keys){
        if([key isKindOfClass:[SCKey class]]){
            [mkeys addObject:key];
        }else if([key isKindOfClass:[NSString class]]){
            [mkeys addObject:[SCKey keyFromString:(NSString *)key]];
        }
    }
    
    [_keys arc_release];
    // Put the modifier keys at the front
    _keys = [[mkeys sortedArrayUsingComparator:^(SCKey *key1, SCKey *key2){
        if([key1 isModifierKey] && ![key2 isModifierKey]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        if(![key1 isModifierKey] && [key2 isModifierKey]){
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }] arc_retain];
    
    [mkeys arc_release];
    
    [self setNeedsDisplay:YES];
}

- (void)setKeysFromStandardUserDefaultForKey:(NSString *)key{
    [self setKeysWithString:[[NSUserDefaults standardUserDefaults] stringForKey:key]];
}

- (void)storeKeysInStandardUserDefaultForKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:[self keysString] forKey:key];
}

- (void)drawBackgroundInRect:(NSRect)rect{
    NSRect boundsRect = NSInsetRect(rect, 1.5f, 1.5f);
    NSRect dropShadowRect = boundsRect;
    dropShadowRect.origin.y -= 1.f;
    [[NSColor whiteColor] setFill];
    NSRectFill(dropShadowRect);
    NSBezierPath *boundsPath = 
    [NSBezierPath bezierPathWithRoundedRect:boundsRect 
                                    xRadius:5.0f yRadius:5.0f];
    NSGradient *gradient = nil;
    if(gradient == nil){
        gradient = 
        [[NSGradient alloc] initWithStartingColor:SCOUTER_TOP_GRADIENT_COLOR 
                                      endingColor:SCOUTER_BOTTOM_GRADIENT_COLOR];
    }
    [gradient drawInBezierPath:boundsPath angle:-90.0f];
    
    static CGImageRef noisePattern = nil;
    if (noisePattern == nil){
        noisePattern = createNoiseImageRef(128, 128, 0.015f);
    }
    [NSGraphicsContext saveGraphicsState];
    [[NSGraphicsContext currentContext] setCompositingOperation:NSCompositePlusLighter];
    CGRect noisePatternRect = CGRectZero;
    noisePatternRect.size = CGSizeMake(CGImageGetWidth(noisePattern), 
                                       CGImageGetHeight(noisePattern));
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextDrawTiledImage(context, noisePatternRect, noisePattern);
    [boundsPath addClip];
    NSRect topShadowRect = 
    NSMakeRect(NSMinX(boundsRect), 
               NSMaxY(boundsRect) - SCOUTER_TOP_SHADOW_DISTANCE, 
               NSWidth(boundsRect), SCOUTER_TOP_SHADOW_DISTANCE);
    NSGradient *topShadowGradient = nil;
    if(topShadowGradient == nil){
        topShadowGradient = 
        [[NSGradient alloc] initWithStartingColor:[NSColor clearColor] 
                                      endingColor:SCOUTER_TOP_SHADOW_COLOR];
    }
    [topShadowGradient drawInRect:topShadowRect angle:90.0f];
    NSRect bottomShadowRect =
    NSMakeRect(NSMinX(boundsRect), NSMinY(boundsRect), 
               NSWidth(boundsRect), SCOUTER_TOP_SHADOW_DISTANCE);
    NSGradient *bottomShadowGradient = nil;
    if(bottomShadowGradient == nil){
        bottomShadowGradient = 
        [[NSGradient alloc] initWithStartingColor:SCOUTER_BOTTOM_SHADOW_COLOR 
                                      endingColor:[NSColor clearColor]];
    }
    [bottomShadowGradient drawInRect:bottomShadowRect angle:90.0f];
    [NSGraphicsContext restoreGraphicsState];
    [SCOUTER_BORDER_COLOR setStroke];
    [boundsPath stroke];    
}

- (NSRect)drawKeyInRect:(NSRect)rect{
    [SCKEY_BORDER_COLOR setStroke];
    [SCKEY_UNDER_COLOR setFill];
    NSBezierPath *underKeyPath = 
    [NSBezierPath bezierPathWithRoundedRect:rect xRadius:3.0f yRadius:3.0f];
    [underKeyPath stroke];
    [underKeyPath fill];
    
    rect.origin.y += 3.0f;        
    rect.size.height -= 3.0f;
    [SCKEY_TOP_GRADIENT_COLOR setFill];
    NSBezierPath *keyPath = 
    [NSBezierPath bezierPathWithRoundedRect:rect xRadius:3.0f yRadius:3.0f];
    [keyPath stroke];
    [keyPath fill];    
    
    return rect;
}

- (void)drawRect:(NSRect)dirtyRect{    
    [self drawBackgroundInRect:self.bounds];
    
    NSRect keyRect = NSInsetRect(self.bounds, 5.5f, 5.5f);
    for(SCKey *key in _keys){
        keyRect.size.width = [key isModifierKey] ? 80.0f : 60.0f;
        
        NSRect keyOffsetRect = [self drawKeyInRect:keyRect];
        [key drawKeyInRect:keyOffsetRect];

        keyRect.origin.x += NSWidth(keyRect)+5.0f;
    }
}

@end
