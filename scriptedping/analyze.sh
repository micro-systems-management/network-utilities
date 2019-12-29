#    Copyright (c) Micro Systems Management 2018, 2019. All rights reserved.
#    
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    Licensed under the GNU-3.0-or-later license. A copy of the
#    GNU General Public License is available in the LICENSE file
#    located in the root of this repository. If not, see
#    <https://www.gnu.org/licenses/>.
#
#!/bin/bash
cd /root/bin/analyze
function convertfrommsgtoeml () {
	cp "$x" "$emaildir"
	msgconvert "$emaildir/$x" --outfile "$emaildir/$d.eml"
}
function exportattachmentfiles () {
	cp "$emaildir/$d.eml" "$attachmentdir"
	munpack -C "$attachmentdir" "$attachmentdir/$d.eml"
	cd "$attachmentdir"
	rm "$attachmentdir/$d.eml"
	mv part1 "$analysisdir/$d (RTF).rtf"
	mv part1.desc "$analysisdir/$d.txt"
}
function hashfiles () {
	cd "$analysisdir"
	find . -type f -exec sha256sum "{}" + > "$d hash values.txt"
	mv "$d hash values.txt" "$reportdir/$d hash values.txt"
}
function createstructure () {
	mkdir "$d"
	pushd "$d"
	mkdir emaildir
	mkdir -p analysisdir/attachmentdir
	mkdir reportdir
	popd
}
function setpaths () {
	casedir=~/"bin/analyze/$d"
	emaildir="$casedir/emaildir"
	analysisdir="$casedir/analysisdir"
	attachmentdir="$analysisdir/attachmentdir"
	reportdir="$casedir/reportdir"
}
function parsemsg () {
	for x in *.msg; do
		d="${x%.*}"
		createstructure
		setpaths
		convertfrommsgtoeml
		exportattachmentfiles
		hashfiles
	done
}
parsemsg
