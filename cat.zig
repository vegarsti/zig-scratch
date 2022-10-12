const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    
    // Read and print lines from standard input
    var buffer: [100]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    while (true) {
        if (stdin.readUntilDelimiterAlloc(allocator, '\n', std.mem.page_size)) |line| {
            try stdout.print("{s}\n", .{line});
        } else |err| switch (err) {
            // EOF
            error.EndOfStream => {
                break;
            },
            // Line is longer than the buffer
            error.StreamTooLong, error.OutOfMemory => {
                try std.io.getStdErr().writer().print("Line was too long: Can only handle lines up to length {d}.\n", .{buffer.len});
                std.os.exit(1);
            },
            else => {
                std.debug.panic("Got unhandled error {s}\n", .{err});
            },
        }
    }
}
