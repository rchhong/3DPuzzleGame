import g4p_controls.*;

GButton backToMenuButton;
GSlider setVolumeSlider;
GDropList songChoiceList;
GSlider setCubeSizeSlider;

public void settingsInit() {
  backToMenuButton = new GButton(this, 200, 300, 100, 50, "Go Back to Menu");
  
  setVolumeSlider = new GSlider(this, 100, 400, 200, 50, 25);
  setVolumeSlider.setLimits(25, 0, 50);
  String[] labels = {"0", "50"};
  setVolumeSlider.setTickLabels(labels);
  setVolumeSlider.setShowTicks(true);
  setVolumeSlider.setShowLimits(true);
  setVolumeSlider.setShowValue(true);
  
  /**songChoiceList = new GDropList(this, 200, 700, 400, 100);
  songChoiceList.addItem("test1");
  songChoiceList.addItem("test2");**/
  
  setCubeSizeSlider = new GSlider(this, 100, 500, 100, 50, 25);
  setCubeSizeSlider.setLimits(3, 2, 5);
  
  setSettingsMenuVisibility(false);
}

public void handleButtonEvents(GButton button, GEvent event) {
  if(button == backToMenuButton && event == GEvent.CLICKED) {
    for(int i = 0; i < startMenu.length; i++) {
        startMenu[i].getBox().pickable(true);
    }
    appState = STARTMENU;
    setSettingsMenuVisibility(false);
    redraw();
  }
}

public void handleSliderEvents(GValueControl slider, GEvent event) {
  
}

public void setSettingsMenuVisibility(boolean value) {
  backToMenuButton.setVisible(value);
  setVolumeSlider.setVisible(value);
  //songChoiceList.setVisible(value);
  setCubeSizeSlider.setVisible(value);
}