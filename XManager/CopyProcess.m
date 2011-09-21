//
//  CopyProcess.m
//  XManager
//
//  Created by demo on 19.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CopyProcess.h"
#import "Stack.h"
#import "InputStream.h"
#import "OutputStream.h"

#define BLOCK_SIZE 1024 * 1024

@interface CopyProcess(Private)

-(bool) isCompleteInner;

+(void) processPlus :(CopyProcess*)this;
-(void) process;
-(bool) isLeaf:(NSString*)node;
-(bool) visitNode:(NSString*)node;
-(void) expandNode:(NSString*)node :(Stack*)stack;

@end

@implementation CopyProcess(Private)

-(bool) isCompleteInner {
    return progress >= 1.0 || stop;
}

+(void) processPlus :(CopyProcess*)this {
    [this process];
}

-(bool) isLeaf:(NSString *)node {
    // Ошибка
    NSError* error = nil;

    // Получим атрибуты
    NSDictionary* attrs = [fileManager attributesOfItemAtPath:node error:&error];

    // Если произошла ошибка
    if (attrs == nil || error != nil) {
        // Возвращая true мы сообщаем, что узел - лист. Тогда при определении размера нужно исходить из того,
        // что узлы для которых нельзя посчитать размер имеют размер 0
        return true;
    }
    
    // Все что не директория - лист
    return ![[attrs objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory];
}

-(bool) visitNode:(NSString*)node {
    
    // Получим имя файла
    NSString* file_name = [node lastPathComponent];
    
    // Откроем поток чтения
    if ([inputStream open:node] == false) {
        return false;
    }
    
    // Откроем поток записи
    if ([outputStream open:[NSString stringWithFormat:@"%@/%@"]] == false) {
        [inputStream close];
        return false;
    }
    
    uint8_t buffer[BLOCK_SIZE] = {0};
    
    bool copy_reslut = true;
    
    for (NSInteger readed = [inputStream read:buffer maxLenght:BLOCK_SIZE]; 
         readed == BLOCK_SIZE; 
         readed = [inputStream read:buffer maxLenght:BLOCK_SIZE]) {
        
        if ([outputStream hasSpaceAvailable] == NO) {
            copy_reslut = false;
            break;
        }
        
        NSInteger writed = [outputStream write:buffer maxLenght:BLOCK_SIZE];
        
        if (writed != BLOCK_SIZE) {
            copy_reslut = false;
            break;
        }
        
        [sync lock];
        done += readed;
        [sync unlock];
    }
    
    [inputStream    close];
    [outputStream   close];
    
    return copy_reslut;
}

-(void) process {
    
    // Стек для обхода дерева в глубину
    Stack* stack = [[Stack alloc] init];
    [stack pushArray:selected];
        
    // Флаг завершения процесса
    bool endProcess = false;
    
    // Пока стек не пуст
    while (![stack isEmpty] && !endProcess) {
        
        // pop
        NSString* node = [stack pop];
        
        if ([self isLeaf:node]) {
            endProcess = [self visitNode:node];
        }
        else {
            [self expandNode:node :stack];
        }
    }
    
//    [stack release];
//    
//    bool endProcess = false;
//    
//    while (endProcess == false) {
//        [sync lock];
//        
//        [NSThread sleepForTimeInterval:0.1f];
//        
//        if (pause == false) {
//            progress += 0.02;
//        }
//        
//        endProcess = [self isCompleteInner];
//        
//        [sync unlock];
//    }
}

@end

@implementation CopyProcess

- (id)init {
    
    self = [super init];
    
    if (self) {
        progress= 0.0f;
        pause   = false;
        sync    = [[NSLock alloc] init];
        fileManager = [[NSFileManager alloc] init];
    }
    
    return self;
}

-(void) dealloc {
    [sync release];
    [fileManager release];
    
    [super dealloc];
}

-(void) runProcess :(NSArray*)s {
    progress = 0.0f;
    pause = false;
    selected = [s retain];
    
    workerThread = [[NSThread alloc] initWithTarget:[CopyProcess class] selector:@selector(processPlus:) object:self];
    [workerThread start];
}

-(double) progress {
    
    double res = 0.0;
    
    [sync lock];
    
    res = progress;
    
    [sync unlock];
    
    return res;
}

-(bool) isComplete {
    
    bool res = false;
    
    [sync lock];
    
    res = [self isCompleteInner];
    
    [sync unlock];
    
    return res;
}

-(void) stopProcess {
    [sync lock];
    
    progress    = 0.0;
    stop        = true;
    workerThread= nil;
    
    [sync unlock];
}

-(void) pauseProcess {
    
    [sync lock];
    
    pause = true;
    
    [sync unlock];
}

-(void) continueProcess {
    
    [sync lock];
    
    pause = false;
    
    [sync unlock];
}



@end
