# Wiimm's ISO Tools - WebAssembly Port

A WebAssembly port of Wiimm's ISO Tools that runs in web browsers for extracting files from Wii disc images (ISO/WBFS files). All operations run locally without uploading files to any server.

This is a quick hack to get the core file extraction functionality working in browsers using Emscripten. The C code has been modified to compile to WebAssembly, and includes a web worker for non-blocking extraction operations.

## Building

You'll need Emscripten (the modified source code is included):

```bash
chmod +x build.sh
./build-script.sh
```

This generates `wit.js` and `wit.wasm` files.

## Usage

Include the files in your web page and create a worker:

```javascript
const worker = new Worker('worker.js');

// Load a disc image
worker.postMessage({
    method: 'setArchiveFile',
    archiveFile: fileFromInput,
    isWBFS: false
});

// Extract a file
worker.postMessage({
    method: 'extractFile',
    filename: 'DATA/sys/main.dol'
});

// Handle results
worker.onmessage = (e) => {
    if (e.data.type === 'fileList') {
        console.log('Files:', e.data.fileList);
    } else if (e.data.type === 'extractFile') {
        // e.data.file contains the extracted blob
    }
};
```

Works with modern browsers that support WebAssembly and web workers.
