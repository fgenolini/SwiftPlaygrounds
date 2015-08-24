
//: Playground - circular buffer for multiple threads

import Cocoa

//: Number of times a thread has started
var threadCalls = 0

var busy = true

enum BufferStatus {
    case NotUsed
    case Writing
    case Written
    case Reading
    case Read
}

struct Buffer {
    var status = BufferStatus.NotUsed
    var revisionId = 0
    var readerCount = 0
    var data = 0
}

var buffer0 = Buffer()
var buffer1 = Buffer()
var buffer2 = Buffer()
var buffer3 = Buffer()
var buffers = [ buffer0, buffer1, buffer2, buffer3 ]
var buffersReader1 = buffers
var buffersReader2 = buffers

var writerRevision = 0

var timesWritten = 0
var timesCouldNotWrite = 0
var timesRead1 = 0
var timesRead2 = 0

func writer() {
    NSThread.sleepForTimeInterval(2.0)
    NSLog("Writer invoked after 2s")
    threadCalls++
    while busy {
        for i in 0..<buffers.count {
            var buf = buffers[i]
            var status = buf.status
            if status == BufferStatus.Reading || status == BufferStatus.Written {
                timesCouldNotWrite++
                continue
            }
            buffers[i].status = BufferStatus.Writing
            NSThread.sleepForTimeInterval(0.15)
            buffers[i].data = threadCalls + timesWritten
            NSThread.sleepForTimeInterval(0.65)
            writerRevision++
            buffers[i].revisionId = writerRevision
            buffers[i].status =  BufferStatus.Written
            timesWritten++
            NSThread.sleepForTimeInterval(0.85)
        }
        NSThread.sleepForTimeInterval(0.7)
    }
}
func reader1() {
    NSThread.sleepForTimeInterval(5.0)
    NSLog("Reader 1 invoked after 5s")
    threadCalls++
    while busy {
        for i in 0..<buffers.count {
            var buf = buffers[i]
            if buf.status == BufferStatus.NotUsed || buf.status == BufferStatus.Writing {
                continue
            }
            if buffersReader1[i].revisionId >= buf.revisionId {
                if buffers[i].readerCount == 0 {
                    buffers[i].status = BufferStatus.Read
                }
                continue
            }
            buffers[i].status = BufferStatus.Reading
            buffers[i].readerCount++
            NSThread.sleepForTimeInterval(1.1)
            buffersReader1[i] = buffers[i]
            NSThread.sleepForTimeInterval(1.1)
            buffers[i].readerCount--
            if buffers[i].readerCount == 0 {
                buffers[i].status = BufferStatus.Read
            }
            timesRead1++
            NSThread.sleepForTimeInterval(0.5)
        }
        NSThread.sleepForTimeInterval(0.5)
    }
}
func reader2() {
    NSThread.sleepForTimeInterval(7.0)
    NSLog("Reader 2 invoked after 7s")
    threadCalls++
    while busy {
        for i in 0..<buffers.count {
            if buffers[i].status == BufferStatus.NotUsed || buffers[i].status == BufferStatus.Writing {
                continue
            }
            if buffersReader2[i].revisionId >= buffers[i].revisionId {
                if buffers[i].readerCount == 0 {
                    buffers[i].status = BufferStatus.Read
                }
                continue
            }
            buffers[i].status = BufferStatus.Reading
            buffers[i].readerCount++
            NSThread.sleepForTimeInterval(0.8)
            buffersReader2[i] = buffers[i]
            NSThread.sleepForTimeInterval(0.8)
            buffers[i].readerCount--
            if buffers[i].readerCount == 0 {
                buffers[i].status = BufferStatus.Read
            }
            timesRead2++
            NSThread.sleepForTimeInterval(0.25)
        }
        NSThread.sleepForTimeInterval(0.4)
    }
}
func CreateThread(block: dispatch_block_t!) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
}

NSLog("Starting")
CreateThread({ reader2() })
CreateThread({ reader1() })
CreateThread({ writer() })

/*: Infinite loop for testing only
To be able to see the output of the threads,
run the main thread for a long enough time, or forever:

    while(true) {}
*/
while threadCalls < 3 || timesWritten < 10 {
    threadCalls
    timesWritten
    timesCouldNotWrite
    timesRead1
    timesRead2
    NSThread.sleepForTimeInterval(1)
}
busy = false

