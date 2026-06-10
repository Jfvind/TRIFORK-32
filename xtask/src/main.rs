use std::env;
use std::fs;
use xshell::{Shell, cmd};

// ====================
// Configurations
// ====================
const WILDCAT_DIR: &str = "wildcat";
const TOP_MODULE: &str = "wildcat/src/main/scala/rvsoc/RustSoCTop.scala";
const V_FILE: &str = "wildcat/generated/RustSoCTop.v";
const BUILD_DIR: &str = "hw/vivado";
const BIN_FILE: &str = "hw/vivado/system.runs/impl_1/RustSoCTop.bin";

const RUST_DIR: &str = "sw/program";
const RUST_TARGET: &str = "riscv32i-unknown-none-elf";
const RUST_RELEASE: &str = "target/riscv32i-unknown-none-elf/release/program";
const DEFAULT_PORT: &str = "COM5";

fn main() -> Result<(), xshell::Error> {
    // Running shell commands in the root
    let sh = Shell::new()?;

    // Arguments parsed (e.g 'cargo xtask upload COM6')
    let mut args = env::args().skip(1); // skips 'cargo'
    let task = args.next();

    match task.as_deref() {
        Some("build-hw") => build_hw(&sh)?,
        Some("flash") => flash(&sh)?,
        Some("build-rust") => build_rust(&sh)?,
        Some("upload") => {
            let port = args.next().unwrap_or_else(|| DEFAULT_PORT.to_string());
            upload(&sh, &port, false)?;
        }
        Some("hw-test") => {
            let port = args.next().unwrap_or_else(|| DEFAULT_PORT.to_string());
            upload(&sh, &port, true)?;
        }
        Some("sim-test") => sim_test(&sh)?,
        Some("clean") => clean(&sh)?,
        Some("disassemble-rust") => disassemble_rust(&sh)?,
        _ => print_help(),
    }

    Ok(())
}

fn build_hw(sh: &Shell) -> Result<(), xshell::Error> {
    // Check if RustSoCTop.scala changed
    if needs_rebuild(TOP_MODULE, V_FILE) {
        println!("--- Compiling to Verilog ---");
        let sbt_cmd = if cfg!(target_os = "windows") {
            "sbt.bat"
        } else {
            "sbt"
        };
        let _dir = sh.push_dir(WILDCAT_DIR);
        cmd!(sh, "{sbt_cmd}")
            .arg("runMain rvsoc.RustSoCTopGen")
            .run()?;
    }

    // Run synthesis and implementation in Vivado
    if needs_rebuild(V_FILE, BIN_FILE) {
        println!("--- Building FPGA Bitstream ---");
        let vivado_cmd = if cfg!(target_os = "windows") {
            "vivado.bat"
        } else {
            "vivado"
        };
        cmd!(
            sh,
            "{vivado_cmd} -mode batch -notrace -source hw/scripts/build.tcl"
        )
        .run()?;
    } else {
        println!("--- Bitstream is up to date ---");
    }

    Ok(())
}

fn flash(sh: &Shell) -> Result<(), xshell::Error> {
    // Check if rebuilding is needed
    if needs_rebuild(TOP_MODULE, BIN_FILE) {
        println!("--- Bitstream outdated ---");
        cmd!(sh, "cargo xtask build-hw").run()?;
    }

    println!("--- Flashing FPGA ---");
    let vivado_cmd = if cfg!(target_os = "windows") {
        "vivado.bat"
    } else {
        "vivado"
    };
    cmd!(
        sh,
        "{vivado_cmd} -mode batch -notrace -source hw/scripts/flash.tcl -tclargs {BIN_FILE}"
    )
    .run()?;

    Ok(())
}

fn build_rust(sh: &Shell) -> Result<(), xshell::Error> {
    println!("--- Compiling Rust for RISC-V ---");
    let _dir = sh.push_dir(RUST_DIR);
    cmd!(sh, "cargo build --target {RUST_TARGET} --release").run()?;

    // Creating raw binary using LLVM object copy
    let bin_out = format!("../../target/{}/release/program.bin", RUST_TARGET);
    cmd!(
        sh,
        "cargo objcopy --target {RUST_TARGET} --release -- -O binary {bin_out}"
    )
    .run()?;

    Ok(())
}

fn upload(sh: &Shell, port: &str, is_test: bool) -> Result<(), xshell::Error> {
    build_rust(sh)?;

    let bin_path = format!("{}.bin", RUST_RELEASE);
    println!("--- Uploading via {} ---", port);

    if is_test {
        cmd!(sh, "cargo run --release --package uploader -- --port {port} --binary {bin_path} --expect PASS --timeout 10").run()?;
    } else {
        cmd!(
            sh,
            "cargo run --release --package uploader -- --port {port} --binary {bin_path} --listen 5"
        )
        .run()?;
    }

    Ok(())
}

fn sim_test(sh: &Shell) -> Result<(), xshell::Error> {
    let lab_dir = format!("{}/risc-v-lab", WILDCAT_DIR);
    if !sh.path_exists(&lab_dir) {
        let _dir = sh.push_dir(WILDCAT_DIR);
        cmd!(sh, "git clone https://github.com/schoeberl/risc-v-lab.git").run()?;

        // Using WSL if on windows, otherwise just make natively
        let test_dir = "risc-v-lab/tests/simple";
        if cfg!(windows) {
            cmd!(sh, "wsl make -C {test_dir}").run()?;
        } else {
            cmd!(sh, "make -C {test_dir}").run()?;
        }
    }

    let _dir = sh.push_dir(WILDCAT_DIR);
    cmd!(sh, "sbt test").run()?;

    Ok(())
}

fn clean(sh: &Shell) -> Result<(), xshell::Error> {
    println!("Cleaning build directories...");
    let paths_to_remove = vec![BUILD_DIR, ".Xil", "target"];

    for path in paths_to_remove {
        if sh.path_exists(path) {
            if let Err(e) = sh.remove_path(path) {
                eprintln!(
                    "Warning: failed to remove '{}': {}\n  - Ensure no programs (editors, terminals, cargo/rustc) are using files inside the directory.\n  - Try closing VS Code, stopping background cargo processes, or run the shell as Administrator.\n  - You can also remove the folder manually: `Remove-Item -Recurse -Force {}` (PowerShell)",
                    path, e, path
                );
            }
        }
    }

    // Clean up vivado logs
    for file in sh.read_dir(".")? {
        let name = file.to_string_lossy().into_owned();
        if name.ends_with(".log") || name.ends_with(".jou") {
            if let Err(e) = sh.remove_path(file) {
                eprintln!("Warning: failed to remove file '{}': {}", name, e);
            }
        }
    }

    println!("--- Clean complete ---");

    Ok(())
}

fn print_help() {
    println!("Usage: cargo xtask <command> [args]");
    println!("");
    println!("Commands:");
    println!("  build-hw          Generate Verilog and create bitstream with Vivado");
    println!("  flash             Flash the bitstream to the FPGA (Basys3)");
    println!("  build-rust        Format and compile the rust program to RISC-V asm");
    println!("  upload [port]     Compile rust and upload to FPGA (default port: COM5)");
    println!("  hw-test [port]    Upload and listen for 'PASS' (for CI/CD)");
    println!("  sim-test          Run Wildcat Chisel simulation tests");
    println!("  disassemble-rust  View RiscV code generated by rust program");
    println!("  clean             Remove untracked generated files");
}

// =====================
// BONUS FEATURES
// =====================
/// View the RISC-V assembly code that program produces
fn disassemble_rust(sh: &Shell) -> Result<(), xshell::Error> {
    cmd!(sh, "rust-objdump -d {RUST_RELEASE}").run()?;

    Ok(())
}

// =====================
// HELPERS
// =====================
/// Checks if the source file has been updated since the last compilation
fn needs_rebuild(source: &str, target: &str) -> bool {
    let Ok(tgt_meta) = fs::metadata(target) else {
        return true;
    }; // tagret missing
    let Ok(src_meta) = fs::metadata(source) else {
        return false;
    }; // source missing. can't build

    let src_time = src_meta
        .modified()
        .unwrap_or(std::time::SystemTime::UNIX_EPOCH);
    let tgt_time = tgt_meta
        .modified()
        .unwrap_or(std::time::SystemTime::UNIX_EPOCH);

    src_time > tgt_time
}
