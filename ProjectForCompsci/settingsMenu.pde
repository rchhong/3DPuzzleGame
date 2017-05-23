GButton backToMenuButton;
GSlider setVolumeSlider;
GLabel setVolumeLabel;
GButton songChoiceFromFile;
GSlider setCubeSizeSlider;
GLabel setCubeSizeLabel;
GLabel settingsMenuTitle;
GLabel currentSetSong;

public void settingsInit() {
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.RED_SCHEME);
  
  settingsMenuTitle = new GLabel(this, 300, 20, 300, 150, "Settings");
  settingsMenuTitle.setFont(new Font("SansSerif", Font.PLAIN, 60));
  
  backToMenuButton = new GButton(this, width - 150, 50, 100, 100, "Go Back to Menu");
  backToMenuButton.setFont(new Font("SansSerif", Font.PLAIN, 20));
  
  setVolumeSlider = new GSlider(this, 100, 200, 500, 130, 25);
  setVolumeSlider.setLimits(20, 0, 80);
  setVolumeSlider.setTextOrientation(G4P.ORIENT_TRACK);
  setVolumeSlider.setShowTicks(true);
  setVolumeSlider.setNbrTicks(9);
  setVolumeSlider.setEasing(8);
  setVolumeSlider.setNumberFormat(G4P.INTEGER);
  setVolumeSlider.setShowLimits(true);
  setVolumeSlider.setShowValue(true);
  
  setVolumeLabel = new GLabel(this, 100, 160, 200, 100, "Volume of Music");
  setVolumeLabel.setFont(new Font("SansSerif", Font.PLAIN, 20));
  
  songChoiceFromFile = new GButton(this, 100, 520, 400, 100, "Choose Song File (opens in new window)");
  songChoiceFromFile.setFont(new Font("SansSerif", Font.PLAIN, 20));
  
  setCubeSizeSlider = new GSlider(this, 100, 330, 300, 130, 25);
  setCubeSizeSlider.setLimits(3, 2, 6);
  setCubeSizeSlider.setTextOrientation(G4P.ORIENT_TRACK);
  setCubeSizeSlider.setShowTicks(true);
  setCubeSizeSlider.setNbrTicks(5);
  setCubeSizeSlider.setEasing(4);
  setCubeSizeSlider.setNumberFormat(G4P.INTEGER);
  setCubeSizeSlider.setShowLimits(true);
  setCubeSizeSlider.setShowValue(true);
  
  setCubeSizeLabel = new GLabel(this, 100, 290, 500, 100, "Size of Cube (select before game starts)");
  setCubeSizeLabel.setFont(new Font("SansSerif", Font.PLAIN, 20));
  
  currentSetSong = new GLabel(this, 100, 680, 500, 100, "Currently selected song: " + songFileChoice);
  currentSetSong.setFont(new Font("SansSerif", Font.PLAIN, 20));
  
  setSettingsMenuVisibility(false);
}

public void handleButtonEvents(GButton button, GEvent event) {
  if(button == backToMenuButton && event == GEvent.CLICKED) {
    if(!gameInitNotOccured) {
      appState = PAUSEMENU;
      setPauseMenuVisibility(true);
      setSettingsMenuVisibility(false);
    }
    else {
      for(int i = 0; i < startMenu.length; i++) {
          startMenu[i].getBox().pickable(true);
      }
      appState = STARTMENU;
      setSettingsMenuVisibility(false);
      redraw();
    }
  }
  
  if(button == songChoiceFromFile && event == GEvent.CLICKED) {
    songFileChoice = G4P.selectInput("Choose song file:", "mp3", "Music file");
    if(songFileChoice.equals(null)) {
      songFileChoice = "audio.mp3";
      currentSetSong.setText("Currently selected song: Default");
    }
    else {
      currentSetSong.setText("Currently selected song: " + songFileChoice);
    }
  }
  
  if(button == continueGameButton && event == GEvent.CLICKED) {
    for(int i = 0; i < puzzle.length; i++) {
      for(int j = 0; j < puzzle.length; j++) {
        for(int x = 0; x < puzzle.length; x++) {
          puzzle[i][j][x].getBox().pickable(true);
        }
      }
    }
    appState = GAME;
    song.play();
    setPauseMenuVisibility(false);
  }
  
  if(button == restartGameButton && event == GEvent.CLICKED) {
    gameInit();
    appState = GAME;
    setPauseMenuVisibility(false);
  }
  
  if(button == goToSettingsMenuButton && event == GEvent.CLICKED) {
    setPauseMenuVisibility(false);
    appState = SETTINGS;
    setSettingsMenuVisibility(true);
  }
  
  if(button == exitGameButton && event == GEvent.CLICKED) {
    System.exit(0);
  }
}

public void handleSliderEvents(GValueControl slider, GEvent event) {
}

public void setSettingsMenuVisibility(boolean value) {
  backToMenuButton.setVisible(value);
  setVolumeSlider.setVisible(value);
  setCubeSizeSlider.setVisible(value);
  setCubeSizeLabel.setVisible(value);
  setVolumeLabel.setVisible(value);
  songChoiceFromFile.setVisible(value);
  settingsMenuTitle.setVisible(value);
  currentSetSong.setVisible(value);
}