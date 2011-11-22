//
//  NSObject+ARC.h
//  SCKeyRecorder
//
//  Created by David Keegan on 11/22/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_feature(objc_arc)
#define ARCSuperDealloc
#else
#define ARCSuperDealloc [super dealloc]
#endif

@interface NSObject (ARC)

- (id)arc_retain;
- (void)arc_release;
- (id)arc_autorelease;

@end
