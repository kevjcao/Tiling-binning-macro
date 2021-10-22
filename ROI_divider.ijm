#@ int(label="Array size (n x n)?") n
#@File(label = "Output directory", style = "directory") output

if (roiManager("Count") > 0) {
	roiManager("Delete");
}

id = getImageID(); 
title = getTitle(); 

getLocationAndSize(coordX, coordY, w, h); 
width = getWidth(); 
height = getHeight(); 
tileWidth = width / n; 
//tileHeight = height; //use this line for column ROIs
tileHeight = height / n;

for (y = 0; y < n; y++) { 
    nY = y * height / n; 
    for (x = 0; x < n; x++) { 
        nX = x * width / n;  
		selectImage(id);
		call("ij.gui.ImageWindow.setNextLocation", coordX + nX, coordY + nY); 
		//makeRectangle(offsetX, 0, tileWidth, tileHeight); //use this line for column ROIs
		makeRectangle(nX, nY, tileWidth, tileHeight);
		roiManager("Add");
    }
}
roiManager("Multi Measure");
saveAs("Results", output+ "/" + title + ".csv");
