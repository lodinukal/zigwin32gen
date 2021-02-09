usingnamespace @import("win32").everything;

pub export fn WinMainCRTStartup() callconv(@import("std").os.windows.WINAPI) c_int {
    // TODO: call getstdhandle and writefile
    const hStdOut = GetStdHandle(STD_OUTPUT_HANDLE);
    if (hStdOut == INVALID_HANDLE_VALUE) {
        //std.debug.warn("Error: GetStdHandle failed with {}\n", .{GetLastError()});
        return -1; // fail
    }
    writeAll(hStdOut, "Hello, World!") catch return -1; // fail
    return 0; // success
}

fn writeAll(hFile: HANDLE, buffer: []const u8) !void {
    var written : usize = 0;
    while (written < buffer.len) {
        const next_write = @intCast(u32, 0xFFFFFFFF & (buffer.len - written));
        var last_written : u32 = undefined;
        // TODO: removing const from ptr is a workaround for: https://github.com/microsoft/win32metadata/issues/211
        //       that issue has been fixed but we're waiting for the next release of win32metadata
        if (1 != WriteFile(hFile, @intToPtr([*]u8, @ptrToInt(buffer.ptr + written)), next_write, &last_written, null)) {
            // TODO: return from GetLastError
            return error.WriteFileFailed;
        }
        written += last_written;
    }
}
