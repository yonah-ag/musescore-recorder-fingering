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
 *
 *  Releases
 *  --------
 *  1.0.0 : Initial release
 *  1.0.1 : Add UI dialog for parameters
 */

import MuseScore 3.0
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1

MuseScore
{
   description: "Recorder Fingering";
   requiresScore: true;
   version: "1.0.1";
   menuPath: "Plugins.Recorder Fingering";

   pluginType: "dialog";
   width:  270;
   height: 165;

   property var okFont: true; // flag to indicate if recorder font present
   property var pXoff: 0.5; // text X-Offset
   property var pYoff: 2.5; // text Y-Offset
   property var pHole: 2.0; // hole size from 0.0 to 10.0 (Tiny to Huge)
   property var pAuto: false; // autoplacement: true or false
   property var pFingers: ["a","z","s","x","d","f","v","g","b","h","n","j",
                           "q","2","w","3","e","r","%","t","6","y","8","u"];
   property var nofApply: 0; // Count of "Apply" presses for use with "Undo"

   onRun:
   {
      if (Qt.fontFamilies().indexOf("Recorder Font") < 0) {
         fontNotFound.open();
         okFont = false;
         return; // Qt.quit()
      }
   }

   function applyFont()
   {
      if (!okFont) {
         font.NotFound.open();
         return;
      }

      if(isNaN(txtHsize.text))
        pHole = 2
      else {
         pHole = txtHsize.text;
         if (pHole < 0)
            pHole = 2
         else if (pHole > 20)
            pHole = 20;
      }

      if(isNaN(txtXoff.text))
         pXoff = 0
      else
         pXoff = txtXoff.text;

      if(isNaN(txtYoff.text))
         pYoff = 0
      else
         pYoff = txtYoff.text;

      pAuto = (selAuto.currentIndex > 0);

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
      var booApply = false;

      curScore.startCmd();
      for (var stave = staveBeg; stave <= staveEnd; ++stave) {
         cursor.staffIdx = stave;
         cursor.voice = 0;
         cursor.rewind(rewindMode);
         cursor.staffIdx = stave;
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
                     booApply = true;
                  }
               }
            }
            cursor.next();
         }
      }
      curScore.endCmd();
      if (booApply) ++nofApply;
      btnUndo.enabled = (nofApply > 0);
   }

   
   function unApplyFont()
   {
      if (nofApply > 0) {
         cmd("undo");
         --nofApply;
         btnUndo.enabled = (nofApply > 0);
      }
   }

   
   GridLayout { id: winUI
   
      anchors.fill: parent
      anchors.margins: 5
      columns: 3
      columnSpacing: 2
      rowSpacing: 2

      Label { id: lblNoFont
         visible : !okFont
         text: "Recorder font is missing"
         Layout.preferredWidth: 70
      }
      Label { id: lblHsize
         visible : okFont
         text: "Hole size"
         Layout.preferredWidth: 70
      }
      TextField { id: txtHsize
         visible: okFont
         enabled: okFont
         Layout.preferredWidth: 60
         Layout.preferredHeight: 30
         text: "2.0"
      }
      Button { id: btnApply
         visible: okFont
         enabled: okFont
         Layout.preferredWidth: 70
         Layout.preferredHeight: 30
         text: "Apply"
         onClicked: applyFont()
      }
      Label { id: lblXoff
         visible : okFont
         text: "X-Offset"
      }
      TextField { id: txtXoff
         visible: okFont
         enabled: okFont
         Layout.preferredWidth: 60
         Layout.preferredHeight: 30
         text: "0.0"
      }
      Button { id: btnUndo
         visible: okFont
         enabled: okFont
         Layout.preferredWidth: 70
         Layout.preferredHeight: 30
         text: "Undo"
         onClicked: unApplyFont()
      }
      Label { id: lblYoff
         visible : okFont
         text: "Y-Offset"
      }
      TextField { id: txtYoff
         visible: okFont
         enabled: okFont
         Layout.preferredWidth: 60
         Layout.preferredHeight: 30
         text: "0.0"
      }
      Label { id: lblNulA // null layout formatter
         visible: okFont
         text: ""
      }
      Label { id: lblAuto
         visible : okFont
         text: "Autoplace"
      }
      ComboBox { id: selAuto
         visible: okFont
         Layout.preferredWidth: 60
         Layout.preferredHeight: 30
         currentIndex: 0
         model: ListModel { id: selAutoList
            ListElement { text: "No"  }
            ListElement { text: "Yes" }
         }
      }
   } // GridLayout

   MessageDialog { id: fontNotFound
      standardButtons: StandardButton.Ok
      title: "Missing Font"
      text: "The recorder font is not installed on your device."
      detailedText: "Please install\n\n" +
                    "RecorderFont.ttf\n\n" +
                    "and then restart MuseScore for it to recognize the new font."
      onAccepted: {}
   }   
}