function writefloattif(timg,filename)

img=single(timg);


t = Tiff(filename, 'w');
tagstruct.ImageLength = size(img, 1);
tagstruct.ImageWidth = size(img, 2);
tagstruct.Compression = Tiff.Compression.None;
tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample = 32;
tagstruct.SamplesPerPixel = 1;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
t.setTag(tagstruct);
t.write(img);
t.close();