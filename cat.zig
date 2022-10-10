const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    
    // Read and print lines from standard input, line length <= 100
    var buffer: [100]u8 = undefined;
    while (true) {
        const inputLine = try readLine(stdin, &buffer);
        if (inputLine == null) break;
        try stdout.print("{s}\n", .{inputLine});
    }
}

/// readLine returns the next line, or null if we encounter a known error. We panic if we encounter an unknown error
fn readLine(reader: std.fs.File.Reader, buffer: []u8) !?[]const u8 {
    if (reader.readUntilDelimiter(buffer, '\n')) |line| {
        return line;
    } else |err| switch (err) {
        // EOF
        error.EndOfStream => {
            return null;
        },
        // Line is longer than the buffer
        error.StreamTooLong => {
            try std.io.getStdOut().writer().print("Line was too long: Can only handle lines up to length {d}.\n", .{buffer.len});
            return null;
        },
        else => {
            std.debug.panic("Got unhandled error {s}\n", .{err});
        },
    }
}

// readLine with allocation?
// Use reader.readUntilDelimiterAlloc
