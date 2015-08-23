
//: Playground - different ways of creating threads in Swift

import Cocoa

//: Number of times a thread has started
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

/*: Loop to keep main thread alive
To be able to see the output of the threads,
run the main thread for a long enough time, or forever:

    while(true) {}
*/
while (threadCalls < 6) {
    NSThread.sleepForTimeInterval(1)
    threadCalls
}

