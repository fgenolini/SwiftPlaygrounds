//: Playground - noun: a place where people can play

import Cocoa

var threadCalls = 0

@objc class SayFunction {
    func sayOne() {
        NSThread.sleepForTimeInterval(5.0)
        NSLog("First method invoked after 5s")
        threadCalls++
    }
    
    func sayTwo() {
        NSThread.sleepForTimeInterval(10.0)
        NSLog("Second method invoked after 10s")
        threadCalls++
    }
    
    func sayThree() {
        NSThread.sleepForTimeInterval(15.0)
        NSLog("Third method invoked after 15s")
        threadCalls++
    }
}

let hello = SayFunction()
let thread1 = NSThread(target: hello, selector: "sayOne", object: nil)
let thread2 = NSThread(target: hello, selector: "sayTwo", object: nil)
let thread3 = NSThread(target: hello, selector: "sayThree", object: nil)
thread1.start()
thread2.start()
thread3.start()

func one() {
    NSThread.sleepForTimeInterval(22.0)
    NSLog("Method 1 invoked after 22s")
    threadCalls++
}

func two() {
    NSThread.sleepForTimeInterval(25.0)
    NSLog("Method 2 invoked after 25s")
    threadCalls++
}

func three() {
    NSThread.sleepForTimeInterval(27.0)
    NSLog("Method 3 invoked after 27s")
    threadCalls++
}

NSLog("Starting")
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    { three() })
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    { two() })
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    { one() })

/*:
To be able to see the output of the threads,
run the main thread for a long enough time:
    while(true) {}
*/
while (threadCalls < 6) {
    NSThread.sleepForTimeInterval(1)
    threadCalls
}

