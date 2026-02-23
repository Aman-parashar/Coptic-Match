
#include <UIKit/UIKit.h>


@interface NSMutableArray (Custom)
- (NSMutableArray *)replaceNullsWithObject:(id)object;
@end

@interface NSMutableDictionary (Custom)
- (NSMutableDictionary *)replaceNullsWithObject:(id)object;
@end
