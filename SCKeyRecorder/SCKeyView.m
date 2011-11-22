//
//  SCKeyView.m
//  SCKeyRecorder
//
//  Created by David Keegan on 11/21/11.
//

#import "SCKeyView.h"
#import <QuartzCore/QuartzCore.h>

#define kBackgroundShadowBlurRadius 4.f

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
    
    // Put the modifier keys at the front
    _keys = [[mkeys sortedArrayUsingComparator:^(SCKey *key1, SCKey *key2){
        if([key1 isModifierKey] && ![key2 isModifierKey]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        if(![key1 isModifierKey] && [key2 isModifierKey]){
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }] retain];
    
    [mkeys release];
    
    [self setNeedsDisplay:YES];
}

- (void)setKeysFromStandardUserDefaultForKey:(NSString *)key{
    [self setKeysWithString:[[NSUserDefaults standardUserDefaults] stringForKey:key]];
}

- (void)storeKeysInStandardUserDefaultForKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:[self keysString] forKey:key];
}

- (void)drawRect:(NSRect)dirtyRect{
    NSRect boundsRect = NSInsetRect(self.bounds, 1.5f, 1.5f);
    NSRect dropShadowRect = boundsRect;
    dropShadowRect.origin.y -= 1.f;
    [[NSColor whiteColor] setFill];
    NSRectFill(dropShadowRect);
    NSBezierPath *boundsPath = [NSBezierPath bezierPathWithRoundedRect:boundsRect xRadius:5.0f yRadius:5.0f];
    NSColor *startColor = [NSColor colorWithDeviceRed:0.851 green:0.851 blue:0.851 alpha:1.00];
    NSColor *endColor = [NSColor colorWithDeviceRed:0.694 green:0.694 blue:0.694 alpha:1.00];
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
    [gradient drawInBezierPath:boundsPath angle:90];
#if !__has_feature(objc_arc)
    [gradient release];
#endif
    static CIImage *noisePattern = nil;
    if (!noisePattern) {
        CIFilter *randomGenerator = [CIFilter filterWithName:@"CIColorMonochrome"];
        [randomGenerator setValue:[[CIFilter filterWithName:@"CIRandomGenerator"] valueForKey:@"outputImage"]
                           forKey:@"inputImage"];
        [randomGenerator setDefaults];
#if __has_feature(objc_arc)
        noisePattern = [randomGenerator valueForKey:@"outputImage"];
#else
        noisePattern = [[randomGenerator valueForKey:@"outputImage"] retain];
#endif
    }
    [NSGraphicsContext saveGraphicsState];
    [boundsPath addClip];
    [noisePattern drawAtPoint:NSZeroPoint fromRect:self.bounds operation:NSCompositePlusLighter fraction:0.04];
    [NSGraphicsContext restoreGraphicsState];
    [[NSColor blackColor] setStroke];
    [boundsPath stroke];
    NSRect shadowRect = boundsRect;
    shadowRect.origin.x -= kBackgroundShadowBlurRadius;
    shadowRect.size.width += kBackgroundShadowBlurRadius * 2.f;
    NSBezierPath *shadowPath = [NSBezierPath bezierPathWithRoundedRect:shadowRect xRadius:5.f yRadius:5.f];
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor colorWithDeviceWhite:0.f alpha:0.6f]];
    [shadow setShadowBlurRadius:kBackgroundShadowBlurRadius];
    [shadow setShadowOffset:NSMakeSize(0.f, -2.f)];
    [NSGraphicsContext saveGraphicsState];
    [shadow set];
    [boundsPath addClip];
    [shadowPath stroke];
    [NSGraphicsContext restoreGraphicsState];
    
    NSRect keyRect = NSInsetRect(self.bounds, 5.5f, 5.5f);
    for(SCKey *key in _keys){
        keyRect.size.width = [key isModifierKey] ? 80.0f : 60.0f;
        NSRect keyOffsetRect = keyRect;
        [[NSColor darkGrayColor] setStroke];
        [[NSColor darkGrayColor] setFill];
        NSBezierPath *underKeyPath = [NSBezierPath bezierPathWithRoundedRect:keyOffsetRect xRadius:3.0f yRadius:3.0f];
        [underKeyPath stroke];
        [underKeyPath fill];
        
        keyOffsetRect.origin.y += 3.0f;        
        keyOffsetRect.size.height -= 3.0f;
        [[NSColor darkGrayColor] setStroke];  
        [[NSColor colorWithDeviceWhite:0.9f alpha:1.0f] setFill];
        NSBezierPath *keyPath = [NSBezierPath bezierPathWithRoundedRect:keyOffsetRect xRadius:3.0f yRadius:3.0f];
        [keyPath stroke];
        [keyPath fill];
        
        [key drawKeyInRect:keyOffsetRect];

        keyRect.origin.x += keyRect.size.width+5.0f;
    }
}

@end
