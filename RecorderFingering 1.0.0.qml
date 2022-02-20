/*
 *  MuseScore Plugin: Recorder Fingerings
 *
 *  This plugin adds recorder fingerings to notes in voice 1 of a score,
 *  either to selected measures or to the entire score.
 *  The free font RecorderFont.ttf is required.
 *
 *  Copyright (C) 2022 yonah_ag
 *
 *  This program is free software; you can redistribute it or modify it under
 *  the terms of the GNU General Public License version 3 as published by the
 *  Free Software Foundation and appearing in the accompanying LICENCE file.
 */

import MuseScore 3.0
import QtQuick.Dialogs 1.1

MuseScore
{
   description: "Recorder Fingering";
   requiresScore: true;
   version: "1.0.0";
   menuPath: "Plugins.Recorder Fingering";

   property var pXoff: 0.5; // text X-Offset
   property var pYoff: 2.5; // text Y-Offset
   property var pHole: 2.0; // hole size from 0.0 to 10.0 (Tiny to Huge)
   property var pAuto: false; // autoplacement: true or false
   property var pFingers: ["a","z","s","x","d","f","v","g","b","h","n","j",
                           "q","2","w","3","e","r","%","t","6","y","8","u"];

   onRun:
   {
      if (Qt.fontFamilies().indexOf("Recorder Font") < 0)
         fontNotFound.open();
      else
         applyFont()

      Qt.quit()
   }

   function applyFont()
   {
      var args = Array.prototype.slice.call(arguments, 1);
      var staveBeg;
      var staveEnd;
      var tickEnd;
      var rewindMode;
      var toEOF;
      var cursor = curScore.newCursor();

      cursor.rewind(Cursor.SELECTION_START);
      if (cursor.segment) {
         staveBeg = cursor.staffIdx;
         cursor.rewind(Cursor.SELECTION_END);
         staveEnd = cursor.staffIdx;
         if (!cursor.tick) {
            toEOF = true;
         }
         else
         {
            toEOF = false;
            tickEnd = cursor.tick;
         }
         rewindMode = Cursor.SELECTION_START;
      }
      else
      {
         staveBeg = 0; // no selection
         staveEnd = curScore.nstaves - 1;
         toEOF = true;
         rewindMode = Cursor.SCORE_START;
      }
      var fontSize = 12 * pHole + 36;

      for (var stave = staveBeg; stave <= staveEnd; ++stave) {
         cursor.staffIdx = stave;
         cursor.voice = 0;
         cursor.rewind(rewindMode);
         cursor.staffIdx = stave;
//         cursor.voice = 0;
         while (cursor.segment && (toEOF || cursor.tick < tickEnd))
         {
            if (cursor.element) {
               if(cursor.element.type == Element.CHORD) {
                  var pitch = cursor.element.notes[0].pitch;
                  var index = pitch - 72;
                  if(index >= 0 && index < pFingers.length){ 
                     var txt = newElement(Element.STAFF_TEXT);
                     txt.text = pFingers[index];
                     txt.placement = Placement.BELOW;
                     txt.offsetX = pXoff;
                     txt.offsetY = pYoff;
                     txt.align = 2; // LEFT = 0, RIGHT = 1, HCENTER = 2, TOP = 0, BOTTOM = 4, VCENTER = 8, BASELINE = 16
                     txt.fontFace = "Recorder Font";
                     txt.fontSize = fontSize;
                     txt.autoplace = pAuto;
                     cursor.add(txt);
                  }
               }
            }
            cursor.next();
         }
      }
   }

   MessageDialog { id: fontNotFound
      standardButtons: StandardButton.Ok
      title: "Missing Font"
      text: "The recorder font is not installed on your device."
      detailedText: "Please install\n\n" +
                    "RecorderFont.ttf\n\n" +
                    "and then restart MuseScore for it to recognize the new font."
      onAccepted: Qt.quit()
   }   
}
