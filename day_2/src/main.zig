const std = @import("std");
const allocator = std.heap.page_allocator;

// Prompt: https://adventofcode.com/2023/day/2
//
// 1. Determine if each game was possible with 12 red, 13 green,
// and 14 blue cubes
// 2. Add all the ids of the games that were possible
//
// Examples:
// Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
// Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
// Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
// Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
// Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
//
// Results:
// Games 1, 2, 5 are possible, and adding those ids = 8
// Game 3 is not possible because at one point there were 20 red cubes
// Game 4 is not possible because at one point there were 15 blue cubes

pub fn gameIsLegit() !bool {
    return false;
}

pub fn main() !void {
    var ids: usize = 0;

    const file = try std.fs.cwd().openFile("inputs.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var lines: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&lines, '\n')) |line| {
        var line_split = std.mem.splitAny(u8, line, ":;");

        var current_game = line_split.first();
        var current_game_set = std.mem.splitAny(u8, current_game, " ");
        var current_game_name = current_game_set.first();
        _ = current_game_name;
        var current_game_id = current_game_set.rest();
        var current_game_id_value = try std.fmt.parseInt(u32, current_game_id, 10);
        var current_results = line_split.rest();
        var current_results_set = std.mem.splitAny(u8, current_results, ",;");

        var isValid: bool = true;

        while (current_results_set.next()) |set| {
            var set_value = std.mem.splitAny(u8, set, " ");
            var set_whitespace = set_value.first();
            _ = set_whitespace;

            var set_score = set_value.rest();

            try std.io.getStdOut().writer().print("Set: {s}\n", .{set_score});

            var set_score_value = std.mem.splitAny(u8, set_score, " ");
            var set_score_value_number = set_score_value.first();
            var score = try std.fmt.parseInt(u32, set_score_value_number, 10);
            var set_color = set_score_value.rest();

            if (std.mem.eql(u8, set_color, "red") and score > 12) {
                isValid = false;
                break;
            }
            if (std.mem.eql(u8, set_color, "green") and score > 13) {
                isValid = false;
                break;
            }
            if (std.mem.eql(u8, set_color, "blue") and score > 14) {
                isValid = false;
                break;
            }

            // try std.io.getStdOut().writer().print("Game: {d}, isValid: {d}\n", .{ current_game_id_value, count });
        }

        if (isValid) {
            ids += current_game_id_value;
        }
    }

    std.debug.print("Total: {any}\n", .{ids});
}
