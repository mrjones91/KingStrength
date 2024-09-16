const std = @import("std");
const zap = @import("zap");

fn on_request(r: zap.Request) void {
    if (r.path) |the_path| {
        std.debug.print("PATH: {s}\n", .{the_path});
        //std.debug.print("r.path type is: {s}", .{@TypeOf(the_path)});
        //const rp = the_path[0..];
        if (std.mem.eql(u8, the_path, "clicked")){
            std.debug.print("idk: {s}\n", .{"work?"});
            r.sendBody("<html><body><h1>Clicked HTMX Response</h1></body></html>") catch return;
        }
    }

    if (r.query) |the_query| {
        std.debug.print("QUERY: {s}\n", .{the_query});
    }

    r.sendBody("<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>King Strength</title></head><body><script src='https://unpkg.com/htmx.org@2.0.2'></script><!-- have a button POST a click via AJAX --><button hx-post='/clicked' hx-swap='outerHTML'>Click Me</button></body></html>") catch return;
}

// const testSettings = struct {
//     .path = "clicked",
//     .get = on_request
// };

// pub fn init(s: testSettings) Endpoint {
//     return .{
//         .settings = .{
//             .path = s.path,
//             .get = s.get orelse &nop,
//             .post = s.post orelse &nop,
//             .put = s.put orelse &nop,
//             .delete = s.delete orelse &nop,
//             .patch = s.patch orelse &nop,
//             .options = s.options orelse &nop,
//             .unauthorized = s.unauthorized orelse &nop,
//         },
//     };
// }

pub fn main() !void {
    var listener = zap.HttpListener.init(.{
        .port = 3000,
        .on_request = on_request,
        .log = true,
        .max_clients = 100000,
    });
    try listener.listen();

    std.debug.print("Listening on 0.0.0.0:3000\n", .{});

    zap.start(.{
        .threads = 2,
        .workers = 1, // 1 worker enables sharing state between threads
    });
}