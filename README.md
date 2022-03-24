# MuseScore Recorder Fingering Plugin

This plugin adds recorder fingering glyphs to notes in voice 1 of a score, either to selected measures or to the entire score. There are 4 settings available which control the position and size of the glyphs.

![01](https://github.com/yonah-ag/musescore-recorder-fingering/blob/main/images/Recorder01-Score.png)

### License

Copyright (C) 2022 yonah_ag

This program is free software; you can redistribute it or modify it under the terms of the GNU General Public License version 3 as published by the Free Software Foundation and appearing in the LICENSE file.  
See https://github.com/yonah-ag/musescore-recorder-fingering/blob/main/LICENSE

RecorderFont.ttf is a freeware font by algomgom and was downloaded from:  
https://www.fontspace.com/recorder-font-f13338

### Installation

_Note: This plugin requires version 3.x of MuseScore._

1. Download RecorderFont.ttf and install it into your OS.
2. Download RecorderFingering.qml then follow the handbook instructions: https://musescore.org/en/handbook/3/plugins

### Using the Plugin

Select a range of measures, or use without selection to apply to all, then from the **Plugins** menu select **Recorder Fingering** and press **Apply**.
 
  ![02](https://github.com/yonah-ag/musescore-recorder-fingering/blob/main/images/Recorder02-Run.png)
  
Plugin settings are available for hole size, x-offset, y-offset and autoplacement:

  ![03](https://github.com/yonah-ag/musescore-recorder-fingering/blob/main/images/Recorder03-Setup.png)
  
  Use the **X** button to close the dialogue.
  
### Additional Info and Links

The plugin covers the note range C5 to C7.

For a soprano recorder this is commonly notated on an octave clef  
where the souding pitches are actually an octave higher than written.

In MuseScore, choosing a recorder as the stave instrument will use  
this ocatve clef. Note the small figure 8 on top of the treble clef.

![04](https://github.com/yonah-ag/musescore-recorder-fingering/blob/main/images/Recorder04-Clef8.png)

Using a standard treble clef, (e.g. violin),  
the range C5 to C7 will appear as:  
![05](https://github.com/yonah-ag/musescore-recorder-fingering/blob/main/images/Recorder05-Clef.png)

**Recorder.mscz** : a simple Musescore file for testing the plugin:  
https://github.com/yonah-ag/musescore-recorder-fingering/blob/main/Recorder.mscz

**Notes.md** : development notes, including version history:  
https://github.com/yonah-ag/musescore-recorder-fingering/blob/main/NOTES.md

Link to official MuseScore Project page for this plugin:  
https://musescore.org/en/project/apply-recorder-fingering-glyphs-score
