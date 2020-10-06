# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
DESTINATION="build.tar.gz"
OUTPUT="ShapeCollage.AppImage"


all: clean
	echo "Building: $(OUTPUT)"
	wget --output-document=$(DESTINATION) --continue http://www.shapecollage.com/previous/2.5.3/ShapeCollage-2.5.3.tar.gz

	mkdir --parents build
	tar -xf $(DESTINATION) --directory build

	wget --no-check-certificate --output-document=build.rpm --continue https://forensics.cert.org/centos/cert/8/x86_64/jdk-12.0.2_linux-x64_bin.rpm
	rpm2cpio build.rpm | cpio -idmv

	mkdir --parents AppDir/application
	mkdir -p AppDir/jre

	cp --recursive --force build/Shape\ Collage/* AppDir/application
	cp --recursive --force usr/java/jdk-*/* AppDir/jre

	chmod +x AppDir/AppRun

	export ARCH=x86_64 && bin/appimagetool.AppImage AppDir $(OUTPUT)
	chmod +x $(OUTPUT)
	make clean

clean:
	rm -rf AppDir/application
	rm -rf *.gz
	rm -rf AppDir/jre
	rm -rf build
	rm -rf usr
