const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "cppfront",
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibCpp();
    exe.addCSourceFiles(
        &.{ "source/cppfront.cpp" },
        &.{ "-std=c++20" },
    );
    exe.addIncludePath(.{ .path = "source" });

    b.installArtifact(exe);
    b.getInstallStep().dependOn(
        &b.addInstallHeaderFile("include/cpp2util.h", "cpp2util.h").step
    );

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
