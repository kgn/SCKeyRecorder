//
//  NSObject+ARC.m
//  SCKeyRecorder
//
//  Created by David Keegan on 11/22/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import "NSObject+ARC.h"

@implementation NSObject (ARC)

- (id)arc_retain{
#if __has_feature(objc_arc)
    return self;
#else
    return [self retain];
#endif
}

- (void)arc_release{
#if !__has_feature(objc_arc)
    [self release];
#endif
}

- (id)arc_autorelease{
#if __has_feature(objc_arc)
    return self;
#else
    return [self autorelease];
#endif
}

@end
