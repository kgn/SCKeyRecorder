//
//  SCARC.h
//  SCKeyRecorderSample
//
//  Created by David Keegan on 11/21/11.
//

#if __has_feature(objc_arc)
#define SCARCRetain(obj) obj
#define SCARCRelease(obj)
#define SCARCAutoRelease(obj) obj
#define SCARCSuperDealloc
#else
#define SCARCRetain(obj) [obj retain]
#define SCARCRelease(obj) [obj release]
#define SCARCAutoRelease(obj) [obj autorelease]
#define SCARCSuperDealloc [super dealloc]
#endif
