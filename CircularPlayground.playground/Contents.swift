
//: Playground - circular buffer for multiple threads

import Cocoa

//: Number of times a thread has started
var threadCalls = 0

func one() {
    NSThread.sleepForTimeInterval(2.0)
    NSLog("Method 1 invoked after 2s")
    threadCalls++
}
func two() {
    NSThread.sleepForTimeInterval(5.0)
    NSLog("Method 2 invoked after 5s")
    threadCalls++
}
func three() {
    NSThread.sleepForTimeInterval(7.0)
    NSLog("Method 3 invoked after 7s")
    threadCalls++
}
func CreateThread(block: dispatch_block_t!) {
    dispatch_async(
        dispatch_get_global_queue(
            DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    block)
}

NSLog("Starting")
CreateThread({ three() })
CreateThread({ two() })
CreateThread({ one() })

/*: Infinite loop for testing only
To be able to see the output of the threads,
run the main thread for a long enough time, or forever:

    while(true) {}
*/
while (threadCalls < 3) {
    NSThread.sleepForTimeInterval(1)
    threadCalls
}

