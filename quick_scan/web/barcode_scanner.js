// Wrapper function exposed to Dart
window.scanBarcodeFromImage = async function(imageDataUrl, callback) {
  try {
    // Create the reader provided by ZXing
    const codeReader = new ZXing.BrowserMultiFormatReader();
    
    // Create an image element to load the data
    const img = new Image();
    img.src = imageDataUrl;

    img.onload = async function() {
      try {
        // Attempt to decode
        // decodeFromImage is robust and handles resizing/orientation
        const result = await codeReader.decodeFromImage(img);
        
        if (result) {
          callback({
            success: true,
            data: result.text,
            format: result.format ? ZXing.BarcodeFormat[result.format] : 'UNKNOWN'
          });
        } else {
          callback({ success: false, error: 'No code detected' });
        }
      } catch (err) {
        // ZXing throws an error if no code is found, which is normal
        callback({ success: false, error: 'No code found in image' });
      }
    };

    img.onerror = function() {
      callback({ success: false, error: 'Failed to load image data' });
    };

  } catch (e) {
    console.error(e);
    callback({ success: false, error: e.message });
  }
};


