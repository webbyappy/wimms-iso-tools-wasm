#!/bin/bash

# Wiimm's ISO Tools WebAssembly Compilation Script
# Run each command individually to compile the tools

# Set up include flags
INCLUDE_FLAGS="-Iwiimms-iso-tools/project -Iwiimms-iso-tools/project/dclib -Iwiimms-iso-tools/project/setup -Iwiimms-iso-tools/project/text-files -Iwiimms-iso-tools/project/src -Iwiimms-iso-tools/project/src/libwbfs -Iwiimms-iso-tools/project/src/libbz2 -Iwiimms-iso-tools/project/src/lzma -Iwiimms-iso-tools/project/src/crypto -Iwiimms-iso-tools/project/src/ui"

# Define common compilation flags
COMMON_FLAGS="-O2 -DWIT_WASM=1 -D__UNIX__ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -DNO_CONFIG_PATHS -DNO_LOGO -DNO_TERMCAP -DNO_LZMA_ENCODER -D_7ZIP_ST -DNO_TERM_FUNCS -DNO_TERMINAL_SIZE"

echo "=== Compiling DCLIB files ==="

# DCLIB core files (essential)
emcc -c wiimms-iso-tools/project/dclib/dclib-basics.c -o dclib-basics.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/dclib-cli.c -o dclib-cli.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/dclib-color.c -o dclib-color.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/dclib-debug.c -o dclib-debug.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/dclib-file.c -o dclib-file.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/dclib-numeric.c -o dclib-numeric.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/dclib-option.c -o dclib-option.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/dclib-parser.c -o dclib-parser.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/dclib-tables.c -o dclib-tables.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/dclib-ui.c -o dclib-ui.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/dclib-utf8.c -o dclib-utf8.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/dclib-vector.c -o dclib-vector.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/dclib-xdump.c -o dclib-xdump.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/lib-bmg.c -o lib-bmg.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/dclib/lib-dol.c -o lib-dol.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}

# DCLIB optional files (commenting out for minimal build)
# emcc -c wiimms-iso-tools/project/dclib/dclib-color.c -o dclib-color.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
# emcc -c wiimms-iso-tools/project/dclib/dclib-debug.c -o dclib-debug.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
# emcc -c wiimms-iso-tools/project/dclib/dclib-mysql.c -o dclib-mysql.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
# emcc -c wiimms-iso-tools/project/dclib/dclib-network.c -o dclib-network.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
# emcc -c wiimms-iso-tools/project/dclib/dclib-network-linux.c -o dclib-network-linux.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
# emcc -c wiimms-iso-tools/project/dclib/dclib-punycode.c -o dclib-punycode.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
# emcc -c wiimms-iso-tools/project/dclib/dclib-regex.c -o dclib-regex.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
# emcc -c wiimms-iso-tools/project/dclib/dclib-shift-jis.c -o dclib-shift-jis.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
# emcc -c wiimms-iso-tools/project/dclib/dclib-ui.c -o dclib-ui.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
# emcc -c wiimms-iso-tools/project/dclib/dclib-xdump.c -o dclib-xdump.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}

echo "=== Compiling SRC files ==="

# Main source files
emcc -c wiimms-iso-tools/project/src/dclib-utf8.c -o src-dclib-utf8.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/iso-interface.c -o iso-interface.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/lib-bzip2.c -o lib-bzip2.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/lib-ciso.c -o lib-ciso.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/lib-file.c -o lib-file.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/lib-gcz.c -o lib-gcz.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/lib-lzma.c -o lib-lzma.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/lib-sf.c -o lib-sf.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/lib-std.c -o lib-std.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/lib-wdf.c -o lib-wdf.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/lib-wia.c -o lib-wia.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/match-pattern.c -o match-pattern.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/none.c -o none.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/patch.c -o patch.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/titles.c -o titles.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/wbfs-interface.c -o wbfs-interface.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
# emcc -c wiimms-iso-tools/project/src/winapi.c -o winapi.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}  # Windows-specific, skip
emcc -c wiimms-iso-tools/project/src/wit-mix.c -o wit-mix.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/wtest.c -o wtest.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
# emcc -c wiimms-iso-tools/project/src/wwt+wit-cmd.c -o wwt-wit-cmd.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}  # Too many dependency issues, skip for now

echo "=== Compiling LIBWBFS files ==="

# LIBWBFS files
emcc -c wiimms-iso-tools/project/src/libwbfs/cert.c -o cert.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/libwbfs/file-formats.c -o file-formats.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/libwbfs/libwbfs.c -o libwbfs.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/libwbfs/rijndael.c -o rijndael.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/libwbfs/tools.c -o tools.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/libwbfs/wiidisc.c -o wiidisc.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}

echo "=== Compiling LIBBZ2 files ==="

# LIBBZ2 files
emcc -c wiimms-iso-tools/project/src/libbz2/blocksort.c -o blocksort.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/libbz2/bzlib.c -o bzlib.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/libbz2/compress.c -o bz2-compress.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/libbz2/crctable.c -o crctable.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/libbz2/decompress.c -o bz2-decompress.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/libbz2/huffman.c -o huffman.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/libbz2/randtable.c -o randtable.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}

echo "=== Compiling LZMA files ==="

# LZMA files (single-threaded version)
emcc -c wiimms-iso-tools/project/src/lzma/LzFind.c -o LzFind.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/lzma/Lzma2Dec.c -o Lzma2Dec.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/lzma/Lzma2Enc.c -o Lzma2Enc.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/lzma/LzmaDec.c -o LzmaDec.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/lzma/LzmaEnc.c -o LzmaEnc.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}

echo "=== Compiling CRYPTO files ==="

# CRYPTO files (skip assembly files for now, use C fallbacks)
emcc -c wiimms-iso-tools/project/src/crypto/sha1_one.c -o sha1_one.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/crypto/sha1dgst.c -o sha1dgst.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}

echo "=== Compiling UI files ==="

# UI files (commenting out problematic ones)
# emcc -c wiimms-iso-tools/project/src/ui/gen-ui.c -o gen-ui.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}  # Missing text_ui_head
emcc -c wiimms-iso-tools/project/src/ui/ui-wdf.c -o ui-wdf.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/ui/ui-wfuse.c -o ui-wfuse.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/ui/ui-wit.c -o ui-wit.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/ui/ui-wwt.c -o ui-wwt.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}

echo "=== Compiling main executables ==="

# Main executable files
emcc -c wiimms-iso-tools/project/src/wit.c -o wit-main.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/wwt.c -o wwt-main.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/wdf.c -o wdf-main.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}
emcc -c wiimms-iso-tools/project/src/wfuse.c -o wfuse-main.o ${INCLUDE_FLAGS} ${COMMON_FLAGS}

echo "=== Linking WIT (Wii ISO Tool) ==="

# Link WIT
emcc wit-main.o \
dclib-basics.o \
dclib-cli.o \
dclib-color.o \
dclib-debug.o \
dclib-file.o \
dclib-numeric.o \
dclib-option.o \
dclib-parser.o \
dclib-tables.o \
dclib-ui.o \
dclib-utf8.o \
dclib-vector.o \
dclib-xdump.o \
lib-bmg.o \
lib-dol.o \
iso-interface.o \
lib-bzip2.o \
lib-ciso.o \
lib-file.o \
lib-gcz.o \
lib-lzma.o \
lib-sf.o \
lib-std.o \
lib-wdf.o \
lib-wia.o \
match-pattern.o \
patch.o \
titles.o \
wbfs-interface.o \
wit-mix.o \
cert.o \
file-formats.o \
libwbfs.o \
rijndael.o \
tools.o \
wiidisc.o \
blocksort.o \
bzlib.o \
bz2-compress.o \
crctable.o \
bz2-decompress.o \
huffman.o \
randtable.o \
LzFind.o \
Lzma2Dec.o \
Lzma2Enc.o \
LzmaDec.o \
LzmaEnc.o \
sha1_one.o \
sha1dgst.o \
ui-wit.o \
-o wit.js -s FORCE_FILESYSTEM=1 -s ALLOW_MEMORY_GROWTH=1 -s NODERAWFS=1 -s EXIT_RUNTIME=1 -s EXPORTED_FUNCTIONS='["_main"]' -s EXPORTED_RUNTIME_METHODS='["callMain"]' -s NO_EXIT_RUNTIME=0 -s ENVIRONMENT=node -s SYSCALL_DEBUG=0 -s STACK_SIZE=67108864 -s INITIAL_MEMORY=134217728 -Wl,--allow-multiple-definition

echo "=== Linking WWT (Wii WBFS Tool) ==="

# Link WWT
emcc wwt-main.o \
dclib-basics.o \
dclib-cli.o \
dclib-debug.o \
dclib-file.o \
dclib-numeric.o \
dclib-option.o \
dclib-parser.o \
dclib-tables.o \
dclib-utf8.o \
dclib-vector.o \
lib-bmg.o \
lib-dol.o \
src-dclib-utf8.o \
iso-interface.o \
lib-bzip2.o \
lib-ciso.o \
lib-file.o \
lib-gcz.o \
lib-lzma.o \
lib-sf.o \
lib-std.o \
lib-wdf.o \
lib-wia.o \
match-pattern.o \
none.o \
patch.o \
titles.o \
wbfs-interface.o \
wit-mix.o \
wtest.o \
cert.o \
file-formats.o \
libwbfs.o \
rijndael.o \
tools.o \
wiidisc.o \
blocksort.o \
bzlib.o \
bz2-compress.o \
crctable.o \
bz2-decompress.o \
huffman.o \
randtable.o \
LzFind.o \
Lzma2Dec.o \
LzmaDec.o \
sha1_one.o \
sha1dgst.o \
ui-wwt.o \
-o wwt.js -s FORCE_FILESYSTEM=1 -s ALLOW_MEMORY_GROWTH=1 -s NODERAWFS=1 -s EXIT_RUNTIME=1 -s EXPORTED_FUNCTIONS='["_main"]' -s EXPORTED_RUNTIME_METHODS='["callMain"]'

echo "=== Linking WDF (Wii Disc Format Tool) ==="

# Link WDF
emcc wdf-main.o \
dclib-basics.o \
dclib-cli.o \
dclib-debug.o \
dclib-file.o \
dclib-numeric.o \
dclib-option.o \
dclib-parser.o \
dclib-tables.o \
dclib-utf8.o \
dclib-vector.o \
lib-bmg.o \
lib-dol.o \
src-dclib-utf8.o \
iso-interface.o \
lib-bzip2.o \
lib-ciso.o \
lib-file.o \
lib-gcz.o \
lib-lzma.o \
lib-sf.o \
lib-std.o \
lib-wdf.o \
lib-wia.o \
match-pattern.o \
none.o \
patch.o \
titles.o \
wbfs-interface.o \
cert.o \
file-formats.o \
libwbfs.o \
rijndael.o \
tools.o \
wiidisc.o \
blocksort.o \
bzlib.o \
bz2-compress.o \
crctable.o \
bz2-decompress.o \
huffman.o \
randtable.o \
LzFind.o \
Lzma2Dec.o \
LzmaDec.o \
sha1_one.o \
sha1dgst.o \
ui-wdf.o \
-o wdf.js -s FORCE_FILESYSTEM=1 -s ALLOW_MEMORY_GROWTH=1 -s NODERAWFS=1 -s EXIT_RUNTIME=1 -s EXPORTED_FUNCTIONS='["_main"]' -s EXPORTED_RUNTIME_METHODS='["callMain"]'

echo "=== Linking WFUSE (FUSE filesystem tool) ==="

# Link WFUSE
emcc wfuse-main.o \
dclib-basics.o \
dclib-cli.o \
dclib-debug.o \
dclib-file.o \
dclib-numeric.o \
dclib-option.o \
dclib-parser.o \
dclib-tables.o \
dclib-utf8.o \
dclib-vector.o \
lib-bmg.o \
lib-dol.o \
src-dclib-utf8.o \
iso-interface.o \
lib-bzip2.o \
lib-ciso.o \
lib-file.o \
lib-gcz.o \
lib-lzma.o \
lib-sf.o \
lib-std.o \
lib-wdf.o \
lib-wia.o \
match-pattern.o \
none.o \
patch.o \
titles.o \
wbfs-interface.o \
cert.o \
file-formats.o \
libwbfs.o \
rijndael.o \
tools.o \
wiidisc.o \
blocksort.o \
bzlib.o \
bz2-compress.o \
crctable.o \
bz2-decompress.o \
huffman.o \
randtable.o \
LzFind.o \
Lzma2Dec.o \
LzmaDec.o \
sha1_one.o \
sha1dgst.o \
ui-wfuse.o \
-o wfuse.js -s FORCE_FILESYSTEM=1 -s ALLOW_MEMORY_GROWTH=1 -s NODERAWFS=1 -s EXIT_RUNTIME=1 -s EXPORTED_FUNCTIONS='["_main"]' -s EXPORTED_RUNTIME_METHODS='["callMain"]'

echo "=== Compilation Complete ==="
echo "Generated files:"
echo "- wit.js (and wit.wasm)"
echo "- wwt.js (and wwt.wasm)"  
echo "- wdf.js (and wdf.wasm)"
echo "- wfuse.js (and wfuse.wasm)"
echo ""
echo "Test with Node.js:"
echo "node wit.js --help"
echo "node wwt.js --help"
echo "node wdf.js --help"
echo "node wfuse.js --help"