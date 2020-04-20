#!/usr/bin/env python

import sys
import os
import subprocess
from PyQt4 import QtGui, uic


class MyWindow(QtGui.QMainWindow):
    
    def __init__(self):
        super(MyWindow, self).__init__()
        uic.loadUi('gui_uber_createReviewMap.ui', self)
        self.pushButton_coordin.clicked.connect(self.AddRois)
        self.pushButton_ROI.clicked.connect(self.CreateROImap)
        self.pushButton_ShowROIs.clicked.connect(self.ShowROIs)
        self.pushButton_SelectAtlas.clicked.connect(self.SelectAtlas)
        self.pushButton_addAtlas.clicked.connect(self.AddRegions)
        self.pushButton_CreateAtlas.clicked.connect(self.CreateRegionsMap)
        self.pushButton_ShowRegions.clicked.connect(self.ShowRegions)
        self.pushButton_Show.clicked.connect(self.ShowCombined)
        self.pushButton_Combine.clicked.connect(self.CombineMaps)
        self.pushButton_coordin_2.clicked.connect(self.AddRois_GM)
        self.pushButton_ROI_2.clicked.connect(self.CreateROImap_GM)
        self.pushButton_ShowROIs_2.clicked.connect(self.ShowROIs_GM)
        self.pushButton_SelectAtlas_2.clicked.connect(self.SelectAtlas_GM)
        self.pushButton_addAtlas_2.clicked.connect(self.AddRegions_GM)
        self.pushButton_CreateAtlas_2.clicked.connect(self.CreateRegionsMap_GM)
        self.pushButton_ShowRegions_2.clicked.connect(self.ShowRegions_GM)
        self.pushButton_Combine_2.clicked.connect(self.CombineMaps_GM)
        self.pushButton_Show_2.clicked.connect(self.ShowCombined_GM)
        # showing example of coordinate
        self.textEditCoordinates.setPlainText("-49 15 4 600 <- x y z volume ; delete this example")
        self.show()

    def AddRois(self):
        rois = self.textEditCoordinates.toPlainText()
        author = self.lineEdit_Author.displayText().replace(" ", "")
        coordSystem = self.buttonGroup.checkedButton().text()
        analyType = self.comboBox_Analysis.currentText()
        test = str(rois)
        print test.endswith("\n")
        if not test.endswith("\n"):
            rois = rois + "\n"
        
        # check if there are 3 coordinates + volume -- 4 values
        
        roisOut = rois.replace("\n", " " + coordSystem + " " + analyType + " " + author + "\n")
        print roisOut
        self.textEditROIs.setPlainText(self.textEditROIs.toPlainText() + roisOut)
        self.textEditCoordinates.setPlainText("")

    def CreateROImap(self):
        # open file and write in ... self.textBrowserROIs.toPlainText
        fname = "WM_ROIs_" + self.lineEdit_MapName.displayText() + ".csv"
        print fname
        if os.path.isfile(fname):
            print("File exists")
            # add some popUp window or notice...
            #self.update_AP_warn_window('** File exists, use some other Target map name')
        else:
            print("no problem, file is not there yet")
            with open(fname, "w") as f:
                f.write(self.textEditROIs.toPlainText())
            self.textEditROIs.setPlainText("")
            subprocess.call(['./script_afniCreateROIs.sh', fname, "WM"])

    def ShowROIs(self):
        MapName = "WM_ROIs_" + self.lineEdit_MapName.displayText()
        print MapName
        subprocess.call(['./script_afniShowROIs.sh', MapName])

    def SelectAtlas(self):
        print(self.comboBox_Atlas.currentText())
        if self.comboBox_Atlas.currentText() == "CA_N27_ML":
            self.comboBox_Region.clear()
            # open atlas
            with open('atlas_CA_N27_ML.txt', "r") as CA_N27_ML_atlas:
                for x in CA_N27_ML_atlas:
                    self.comboBox_Region.addItem(x)

        if self.comboBox_Atlas.currentText() == "JHU-WhiteMatter-labels":
            self.comboBox_Region.clear()
            # open atlas
            with open('atlas_JHU-WhiteMatter-labels.txt', "r") as JHU_WhiteMatter_atlas:
                for x in JHU_WhiteMatter_atlas:
                    self.comboBox_Region.addItem(x)

        if self.comboBox_Atlas.currentText() == "DD_Desai_PM":
            self.comboBox_Region.clear()
            # open atlas
            with open('atlas_DD_Desai_PM.txt', "r") as DD_Desai_atlas:
                for x in DD_Desai_atlas:
                    self.comboBox_Region.addItem(x)

    def AddRegions(self):
        region = self.comboBox_Region.currentText()
        author = self.lineEdit_AuthorAtlas.displayText().replace(" ", "")
        analyType = self.comboBox_AnalysisAtlas.currentText()
        atlas = self.comboBox_Atlas.currentText()
        # for line in rois:
        #    check if there are 3 koordinates + volume -- 4 values
        print region
        regionOut = region.replace("\n", " " + atlas + " " + analyType + " " + author + "\n")
        self.textBrowser_Aregions.setPlainText(self.textBrowser_Aregions.toPlainText() + regionOut)

    def CreateRegionsMap(self):
        # open file and write in ... self.textBrowserROIs.toPlainText
        fname = "WM_Regions_" + self.lineEdit_MapName.displayText() + ".csv"
        print fname
        if os.path.isfile(fname):
            print("File exists")
            # add some popUp window or notice...
            #self.update_AP_warn_window('** File exists, use some other Target map name')
        else:
            print("no problem, file is not there yet")
            with open(fname, "w") as f:
                f.write(self.textBrowser_Aregions.toPlainText())
            self.textBrowser_Aregions.setPlainText("")
            subprocess.call(['./script_afniCreateRegions.sh', fname])

    def ShowRegions(self):
        MapName = "WM_Regions_" + self.lineEdit_MapName.displayText()
        print MapName
        subprocess.call(['./script_afniShowRegions.sh', MapName])

    def CombineMaps(self):
        MapName = "WM_" + self.lineEdit_MapName.displayText()
        print MapName
        subprocess.call(['./script_afniCombineMaps.sh', MapName])

    def ShowCombined(self):
        MapName = "WM_" + self.lineEdit_MapName.displayText()
        print MapName
        subprocess.call(['./script_afniShowCombined_WM.sh', MapName])

####################################################

    def AddRois_GM(self):
        rois = self.textEditCoordinates_2.toPlainText()
        author = self.lineEdit_Author_2.displayText().replace(" ", "")
        coordSystem = self.buttonGroup_2.checkedButton().text()
        analyType = self.comboBox_Analysis_2.currentText()
        test = str(rois)
        print test.endswith("\n")
        if not test.endswith("\n"):
            rois = rois + "\n"
        # check if there are 3 koordinates + volume -- 4 values
                
        roisOut = rois.replace("\n", " " + coordSystem + " " + analyType + " " + author + "\n")
        print roisOut
        self.textEditROIs_2.setPlainText(self.textEditROIs_2.toPlainText() + roisOut)
        self.textEditCoordinates_2.setPlainText("")

    def CreateROImap_GM(self):
        # open file and write in ... self.textBrowserROIs.toPlainText
        fname = "GM_ROIs_" + self.lineEdit_MapName_2.displayText() + ".csv"
        print fname
        if os.path.isfile(fname):
            print("File exists")
            # add some popUp window or notice...
            #self.update_AP_warn_window('** File exists, use some other Target map name')
        else:
            print("no problem, file is not there yet")
            with open(fname, "w") as f:
                f.write(self.textEditROIs_2.toPlainText())
            self.textEditROIs_2.setPlainText("")
            subprocess.call(['./script_afniCreateROIs.sh', fname, "GM"])

    def ShowROIs_GM(self):
        MapName = "GM_ROIs_" + self.lineEdit_MapName_2.displayText()
        print MapName
        subprocess.call(['./script_afniShowROIs.sh', MapName])

    def SelectAtlas_GM(self):
        print(self.comboBox_Atlas_2.currentText())
        if self.comboBox_Atlas_2.currentText() == "CA_N27_ML":
            self.comboBox_Region_2.clear()
            # open atlas
            with open('atlas_CA_N27_ML.txt', "r") as CA_N27_ML_atlas:
                for x in CA_N27_ML_atlas:
                    self.comboBox_Region_2.addItem(x)

        if self.comboBox_Atlas_2.currentText() == "JHU-WhiteMatter-labels":
            self.comboBox_Region_2.clear()
            # open atlas
            with open('atlas_JHU-WhiteMatter-labels.txt', "r") as JHU_WhiteMatter_atlas:
                for x in JHU_WhiteMatter_atlas:
                    self.comboBox_Region_2.addItem(x)

        if self.comboBox_Atlas_2.currentText() == "DD_Desai_PM":
            self.comboBox_Region_2.clear()
            # open atlas
            with open('atlas_DD_Desai_PM.txt', "r") as DD_Desai_atlas:
                for x in DD_Desai_atlas:
                    self.comboBox_Region_2.addItem(x)

    def AddRegions_GM(self):
        region = self.comboBox_Region_2.currentText()
        author = self.lineEdit_AuthorAtlas_2.displayText().replace(" ", "")
        analyType = self.comboBox_AnalysisAtlas_2.currentText()
        atlas = self.comboBox_Atlas_2.currentText()
        # for line in rois:
        #    check if there are 3 koordinates + volume -- 4 values
        print region
        regionOut = region.replace("\n", " " + atlas + " " + analyType + " " + author + "\n")
        self.textBrowser_Aregions_2.setPlainText(self.textBrowser_Aregions_2.toPlainText() + regionOut)

    def CreateRegionsMap_GM(self):
        # open file and write in ... self.textBrowserROIs.toPlainText
        fname = "GM_Regions_" + self.lineEdit_MapName_2.displayText() + ".csv"
        print fname
        if os.path.isfile(fname):
            print("File exists")
            # add some popUp window or notice...
            #self.update_AP_warn_window('** File exists, use some other Target map name')
        else:
            print("no problem, file is not there yet")
            with open(fname, "w") as f:
                f.write(self.textBrowser_Aregions_2.toPlainText())
            self.textBrowser_Aregions_2.setPlainText("")
            subprocess.call(['./script_afniCreateRegions.sh', fname])

    def ShowRegions_GM(self):
        MapName = "GM_Regions_" + self.lineEdit_MapName_2.displayText()
        print MapName
        subprocess.call(['./script_afniShowRegions.sh', MapName])

    def CombineMaps_GM(self):
        MapName = "GM_" + self.lineEdit_MapName_2.displayText()
        print MapName
        subprocess.call(['./script_afniCombineMaps.sh', MapName])

    def ShowCombined_GM(self):
        MapName = "GM_" + self.lineEdit_MapName_2.displayText()
        print MapName
        subprocess.call(['./script_afniShowCombined_GM.sh', MapName])

if __name__ == '__main__':
    app = QtGui.QApplication(sys.argv)
    myWindow = MyWindow()
    app.exec_()
