#import <Foundation/Foundation.h>

#define MAX_TEST_COUNT 1000000
#define ELEMENT_TEST_COUNT 32000


NSMutableArray *retainIds = nil;
int64_t *originalIds = NULL;
int64_t *findAndDeleteIds = NULL;
int *addAndDeleteIndexs = NULL;

void generate_original_ids()
{
	srand(time(NULL));
	
	retainIds = [NSMutableArray array];
	originalIds = new int64_t[MAX_TEST_COUNT];
	findAndDeleteIds = new int64_t[MAX_TEST_COUNT];
	addAndDeleteIndexs = new int[ELEMENT_TEST_COUNT];
	
	addAndDeleteIndexs[0] = 0;
	for (int i = 1; i < ELEMENT_TEST_COUNT; i ++)
	{
		addAndDeleteIndexs[i] = rand() % i;
	}
	
	for (int i = 0; i < MAX_TEST_COUNT; i ++)
	{
		id obj = [NSNumber numberWithInt:i];
		originalIds[i] = (int64_t)obj;
		findAndDeleteIds[i] = (int64_t)obj;
		[retainIds addObject:obj];
	}
	
	for (int i = 0; i < MAX_TEST_COUNT; i ++)
	{
		int index = rand() % MAX_TEST_COUNT;
		
		int64_t tmp = originalIds[index];
		originalIds[index] = originalIds[i];
		originalIds[i] = tmp; 
	}
}

NSTimeInterval costTime(void(^block)())
{
	NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
	block();
	NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
	return time2 - time1;
}

NSArray * test_number(int count)
{
	NSMutableSet *set = [NSMutableSet set];
	NSMutableArray *arrayObject = [NSMutableArray array];
	NSMutableArray *arrayIndex = [NSMutableArray array];
	NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
	
	// create set
	NSTimeInterval t1 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[set addObject:(__bridge id) (void*)originalIds[index]];
		}
		return;
	});
	
	
	// create NSArray Object
	NSTimeInterval t2 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[arrayObject addObject:(__bridge id) (void*)originalIds[index]];
		}
		return;
	});
	
	// create NSArray Index
	NSTimeInterval t3 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[arrayIndex insertObject:(__bridge id) (void*)originalIds[index] atIndex:addAndDeleteIndexs[index]];
		}
		return;
	});
	
	// create OrderedSet
	NSTimeInterval t4 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[orderedSet addObject:(__bridge id) (void*)originalIds[index]];
		}
		return;
	});
	
	
	
	// find set
	NSTimeInterval t5 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[set containsObject:(__bridge id) (void*)findAndDeleteIds[index]];
		}
		return;
	});
	
	// find array object
	NSTimeInterval t6 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[arrayObject containsObject:(__bridge id) (void*)findAndDeleteIds[index]];
		}
		return;
	});
	
	// find array Index
	NSTimeInterval t7 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[arrayIndex objectAtIndex:index];
		}
		return;
	});
	
	// find orderedset
	NSTimeInterval t8 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[orderedSet containsObject:(__bridge id) (void*)findAndDeleteIds[index]];
		}
		return;
	});
	
	// delete set
	NSTimeInterval t9 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[set removeObject:(__bridge id) (void*)findAndDeleteIds[index]];
		}
		return;
	});
	
	// delete array Object
	NSTimeInterval t10 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[arrayObject removeObject:(__bridge id) (void*)findAndDeleteIds[index]];
		}
		return;
	});
	
	// delete array index
	NSTimeInterval t11 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[arrayIndex removeObjectAtIndex:addAndDeleteIndexs[count - index - 1]];
		}
		return;
	});
	
	// delete orderedset
	NSTimeInterval t12 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[orderedSet removeObject:(__bridge id) (void*)findAndDeleteIds[index]];
		}
		return;
	});
	
	return @[@(t1), @(t2), @(t3), @(t4), @(t5), @(t6), @(t7), @(t8), @(t9), @(t10), @(t11), @(t12)];
}




int main(int argc, char *argv[]) {
	@autoreleasepool {
		assert(ELEMENT_TEST_COUNT < MAX_TEST_COUNT);
		
		generate_original_ids();
		int number = ELEMENT_TEST_COUNT;
		NSArray* result = test_number(number);
		NSLog(@"\nnumber:%d\nadd \t(set:%.7f, arrayObject:%.7f, arrayIndex:%.7f, orderedset:%.7f)\n"
				"find\t(set:%.7f, arrayObject:%.7f, arrayIndex:%.7f, orderedset:%.7f)\n"
				"delete\t(set:%.7f, arrayObject:%.7f, arrayIndex:%.7f, orderedset:%.7f)\n",
				number,
				[result[0] doubleValue],
				[result[1] doubleValue],
				[result[2] doubleValue],
				[result[3] doubleValue],
				[result[4] doubleValue],
				[result[5] doubleValue],
				[result[6] doubleValue],
				[result[7] doubleValue],
				[result[8] doubleValue],
				[result[9] doubleValue],
				[result[10] doubleValue],
				[result[11] doubleValue]
				);
	}
	return 0;
}