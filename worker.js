/* eslint-disable */
// Wiimm's ISO Tools Web Worker

importScripts('wit.js');

let witTool;
let discImageName = '_disc_image';
let fileList = new Set();
let directories = new Set();
let encrypted = false;
let extractionError = false;
let lastErrorMessage = '';
let isWBFS = false;
let gameInfo = {};

self.onmessage = e => {
    switch (e.data.method) {
        case 'setArchiveFile': {                         
            // Treat disc image like archive file for compatibility
            isWBFS = e.data.isWBFS || false;
            getFileList(e.data.archiveFile, isWBFS);
            break;
        }
        case 'extractFile': {             
            extractFile(e.data);
            break;
        }
    }
};

function extractFile(data) {
    try {
        const filename = data.filename; // The path of file to be extracted from the ISO
        const isoMode = data.isoMode || false; // Whether to extract as full ISO
        
        console.log('Extracting file:', filename, 'ISO mode:', isoMode);
        
        // Check if we've already extracted everything
        let hasExtractedAll = false;
        try {
            // Check if extraction marker exists
            witTool.FS.stat('/memfs/.extracted');
            hasExtractedAll = true;
            console.log('Full extraction already completed, serving from cache');
        } catch (e) {
            // Marker doesn't exist, need to do full extraction
            hasExtractedAll = false;
        }
        
        // If we haven't extracted everything yet, do it now
        if (!hasExtractedAll) {
            console.log('Performing full disc extraction...');
            
            // Use a unique extraction directory to avoid conflicts
            const extractDir = '/memfs/extracted';
            
            // Remove existing directory completely to avoid WIT complaints
            try {
                function removeRecursive(path) {
                    const entries = witTool.FS.readdir(path);
                    for (const entry of entries) {
                        if (entry !== '.' && entry !== '..') {
                            const fullPath = path + '/' + entry;
                            const stat = witTool.FS.stat(fullPath);
                            if (witTool.FS.isDir(stat.mode)) {
                                removeRecursive(fullPath);
                                witTool.FS.rmdir(fullPath);
                            } else {
                                witTool.FS.unlink(fullPath);
                            }
                        }
                    }
                }
                
                if (witTool.FS.analyzePath(extractDir).exists) {
                    console.log('Removing existing extraction directory...');
                    removeRecursive(extractDir);
                    witTool.FS.rmdir(extractDir);
                }
            } catch (e) {
                console.log('Could not remove extraction directory:', e);
            }
            
            // Create fresh extraction directory
            witTool.FS.mkdir(extractDir);
            
            let cmd = ['EXTRACT'];
            cmd.push('/workerfs/' + discImageName);
            cmd.push('--dest');
            cmd.push(extractDir);
            cmd.push('--overwrite'); // Force overwrite if needed

            console.log('WIT command:', cmd);
            
            // Reset extraction error flag
            extractionError = false;
            lastErrorMessage = '';
            witTool.callMain(cmd);

            // Check if extraction actually worked by looking at directory contents
            const extractedSuccessfully = checkExtractionSuccess(extractDir);
            
            if (!extractedSuccessfully) {
                throw {name:'ExtractionError', message: 'Extraction failed - no files found in output directory'};
            }
            
            // Create extraction marker
            try {
                witTool.FS.writeFile('/memfs/.extracted', 'complete');
                console.log('Full extraction completed successfully');
            } catch (e) {
                console.warn('Could not create extraction marker:', e);
            }
        }
        
        function checkExtractionSuccess(extractDir) {
            try {
                const entries = witTool.FS.readdir(extractDir);
                console.log('Extracted directory contents:', entries);
                
                // Check if we have more than just . and ..
                const realEntries = entries.filter(e => e !== '.' && e !== '..');
                if (realEntries.length === 0) {
                    console.error('No files extracted to directory');
                    return false;
                }
                
                // Look for the game directory (like P-GLME)
                for (const entry of realEntries) {
                    const entryPath = extractDir + '/' + entry;
                    const stat = witTool.FS.stat(entryPath);
                    if (witTool.FS.isDir(stat.mode)) {
                        console.log('Found extracted game directory:', entry);
                        const subEntries = witTool.FS.readdir(entryPath);
                        console.log('Contents of', entry + ':', subEntries.slice(0, 10)); // Show first 10 items
                    }
                }
                
                return true;
            } catch (e) {
                console.error('Could not verify extraction:', e);
                return false;
            }
        }
        
        witTool.FS.ignorePermissions = true;
        
        let extractedFile;
        
        if (isoMode) {
            // For ISO mode, look for the converted ISO file
            extractedFile = new Blob([witTool.FS.readFile('/memfs/' + discImageName)]);
        } else {
            // Now just find the file in the extracted directory structure
            let extractedPath;
            
            try {
                // First try the full path in the extracted directory
                extractedPath = '/memfs/extracted/' + filename;
                extractedFile = new Blob([witTool.FS.readFile(extractedPath)]);
            } catch (e) {
                // If that fails, try just the filename in extraction root
                try {
                    const justFilename = filename.split('/').pop();
                    extractedPath = '/memfs/extracted/' + justFilename;
                    extractedFile = new Blob([witTool.FS.readFile(extractedPath)]);
                } catch (e2) {
                    // If still failing, search recursively
                    extractedPath = findExtractedFile('/memfs/extracted', filename);
                    if (extractedPath) {
                        extractedFile = new Blob([witTool.FS.readFile(extractedPath)]);
                    } else {
                        throw new Error('Could not locate extracted file: ' + filename);
                    }
                }
            }
        }

        console.log('Successfully returned file, size:', extractedFile.size);
        self.postMessage({ type: 'extractFile', file: extractedFile, filename: filename});
        
    } catch (error) {
        console.error('Extraction error:', error);
        self.postMessage({ type: 'extractFileError', error: error });
        extractionError = false;
    }
}

// Helper function to recursively search for extracted file
function findExtractedFile(searchPath, targetFilename) {
    try {
        const entries = witTool.FS.readdir(searchPath);
        
        for (const entry of entries) {
            if (entry === '.' || entry === '..') continue;
            
            const fullPath = searchPath + '/' + entry;
            const stat = witTool.FS.stat(fullPath);
            
            if (witTool.FS.isDir(stat.mode)) {
                // Recursively search subdirectories
                const found = findExtractedFile(fullPath, targetFilename);
                if (found) return found;
            } else {
                // Check if this is our target file
                if (fullPath.endsWith(targetFilename) || entry === targetFilename.split('/').pop()) {
                    return fullPath;
                }
            }
        }
    } catch (e) {
        console.log('Error searching directory:', searchPath, e);
    }
    
    return null;
}

async function getFileList(discFile, isWBFS) {
    let stdoutBuffer = "";
    let isListing = false;
    let fileCount = 0;
    let currentSection = "";
    
    self.stdOut = function(code) {
        if (code === '\n'.charCodeAt(0) && stdoutBuffer !== '') {
            
            processOutputLine(stdoutBuffer);
            stdoutBuffer = "";
        } else {
            stdoutBuffer += String.fromCharCode(code);
        }
    }

    function processOutputLine(line) {
        // console.log('Processing line:', line); // Debug output
        
        // Skip header lines and empty lines
        if (line.includes('size') || 
            line.includes('dec  path + file') || 
            line.includes('----') ||
            line.includes('file') ||
            line.includes('type     filename') ||
            line.includes('WBFS') ||
            line.trim() === '') {
         //   return;
        }

        // Check for directory lines (start with N=)
        const dirMatch = line.match(/^N=(\d+)\s+(.+)\/$/);
        if (dirMatch) {
            const fileCountInDir = parseInt(dirMatch[1]);
            const dirPath = dirMatch[2];
            
            //console.log('Found directory:', dirPath, 'with', fileCountInDir, 'files');
            
            // Add directory to fileList
            fileList.add(createFileListItem(dirPath, true, 0));
            directories.add(dirPath);
            return;
        }

        // Check for file lines (start with file size) 
        const fileMatch = line.match(/^\s*(\d+)\s+(.+)$/);
        if (fileMatch) {
            const size = parseInt(fileMatch[1]);
            const fullpath = fileMatch[2].trim();
            
            // Skip if it's actually a directory indicator we missed
            if (fullpath.endsWith('/')) {
                //console.log('Skipping directory-like file:', fullpath);
                return;
            }
            
            // Add file to fileList            
            fileList.add(createFileListItem(fullpath, false, size));
            fileCount++;
            
            return;
        }

        // Check for errors
        if (line.includes('ERROR') || line.includes('FAILED')) {
            extractionError = true;
            return;
        }
    }

    try {
        let outputBuffer = '';

        witTool = await WIT({
            print: function(text) { 
                //console.log('WIT OUTPUT:', text);
                outputBuffer += text + '\n';
                
                if (self.stdOut) {
                    for (let i = 0; i < text.length; i++) {
                        self.stdOut(text.charCodeAt(i));
                    }
                    self.stdOut('\n'.charCodeAt(0));
                }
            },
            printErr: function(text) { 
                console.error('WIT ERROR:', text); 
                lastErrorMessage = text;
                if (!text.includes('Destination already exists')) {
                    extractionError = true;
                }
            }
        });
        
        discImageName = discFile.name;
        console.log('Setting up filesystem for disc image:', discImageName);
        
        witTool.FS.mkdir('/workerfs');
        witTool.FS.mkdir('/memfs');
        
        // Mount the disc image file
        witTool.FS.mount(witTool.WORKERFS, {
            blobs: [{ name: discImageName, data: discFile }],
        }, '/workerfs');
        
        witTool.FS.chdir('/workerfs');
        
        console.log('Listing disc image files...');        
        
        witTool.callMain(['FILES-L', '-f', discImageName]);

        if(fileList.size === 0) {
            throw new Error('Could not read file list from disc image');
        }
        
        self.postMessage({ 
            type: 'fileList', 
            fileList, 
            encrypted: false, // Wii discs aren't typically encrypted at file level
            gameInfo: gameInfo 
        });
        
    } catch (ex) {        
        console.log('Error analyzing disc:', ex);
        self.postMessage({ type: 'fileListError', error: ex });
    }
}

function updateDirectories(filename) {
    const directory = filename.split('/').slice(0,-1).join('/');
    
    if (!directories.has(directory) && directory !== '') {        
        // Check parent directories
        let counter = 0;
        let parentParts = directory.split("/");
        do {
            counter++;
            let parent = parentParts.slice(0,-counter).join("/");
            if(!directories.has(parent) && parent !== '') {
                fileList.add(createFileListItem(parent, true, 0));
                directories.add(parent);        
            }
        } while (parentParts.length >= counter);
        
        fileList.add(createFileListItem(directory, true, 0));             
        directories.add(directory);
    }   
}

function createFileListItem(fullpath, isDirectory, size) {    
    const directory = fullpath.split("/").slice(0,-1).join("/");
    const filename = fullpath.split('/').pop();
    const ext = filename.split('.').pop();
    
    return {
        directory,
        filename, 
        fullpath,
        ext, 
        isDirectory, 
        size                    
    };
}

// Additional helper functions for Wii-specific operations
function getDiscInfo() {
    return {
        gameId: gameInfo.gameId,
        title: gameInfo.title,
        region: gameInfo.region,
        format: isWBFS ? 'WBFS' : 'ISO',
        fileCount: fileList.size
    };
}

function convertToISO() {
    try {
        let cmd = ['copy'];
        cmd.push('/workerfs/' + discImageName);
        cmd.push('/memfs/converted.iso');
        cmd.push('--iso');
        
        witTool.callMain(cmd);
        
        const isoFile = new Blob([witTool.FS.readFile('/memfs/converted.iso')]);
        self.postMessage({ type: 'convertedISO', file: isoFile });
    } catch (error) {
        self.postMessage({ type: 'conversionError', error });
    }
}