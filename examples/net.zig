//! test basic network functionality
const std = @import("std");

const win32 = struct {
    usingnamespace @import("win32").windows.win32.foundation;
    usingnamespace @import("win32").windows.win32.networking.win_sock;
    usingnamespace @import("win32").windows.win32.network_management.ip_helper;
};

pub fn main() void {
    var wsaData: win32.WSADATA = undefined;
    _ = win32.WSAStartup(0x202, &wsaData);
    defer _ = win32.WSACleanup();
    const s = win32.socket(@intFromEnum(win32.AF_INET), win32.SOCK_STREAM, @intFromEnum(win32.IPPROTO_TCP));
    if (s == win32.INVALID_SOCKET) {
        std.log.err("socket failed with {}", .{@intFromEnum(win32.GetLastError())});
    }
}
