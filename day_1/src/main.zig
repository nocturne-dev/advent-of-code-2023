const std = @import("std");
const allocator = std.heap.page_allocator;
// Prompt: https://adventofcode.com/2023/day/1
//
// 1. Find the first and last numbers of each string
// 2. Once all the numbers have been found, add them all together
//
// Examples:
// 1abc2 would produce the number 12;
// pqr3stu8vwx would produce the number 38;
// a1b2c3d4e5f would produce the number 15;
// treb7uchet would product the number 77; and finally,
// 12 + 38 + 15 + 77 = 142

pub fn decipher(string: []u8) !usize {
    var left: u8 = 0;
    var right: u8 = 0;
    var counter: usize = 0;

    while (counter < string.len) : (counter += 1) {
        var first = string[counter];
        var last = string[string.len - counter - 1];

        if (left < 48 or left > 57) {
            left = if (first >= 48 and first <= 57) first else 0;
        }

        if (right < 48 or right > 57) {
            right = if (last >= 48 and last <= 57) last else 0;
        }

        if (left > 0 and right > 0) break;
    }

    if (left == 0 or right == 0) return 0;

    const answer = [_]u8{ left, right };
    const converted = std.fmt.parseInt(usize, &answer, 10);
    return converted;
}

pub fn main() !void {
    var total: usize = 0;

    const file = try std.fs.cwd().openFile("inputs.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var ciphers: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&ciphers, '\n')) |line| {
        const num = try decipher(line);
        try std.io.getStdOut().writer().print("Number: {any}\n", .{num});
        total += num;
    }

    try std.io.getStdOut().writer().print("Total: {any}\n", .{total});
}
