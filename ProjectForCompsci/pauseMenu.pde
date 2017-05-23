GLabel pauseMenuTitle;
GButton continueGameButton;
GButton restartGameButton;
GButton exitGameButton;
GButton goToSettingsMenuButton;

public void pauseMenuInit() {
  pauseMenuTitle = new GLabel(this, (width / 2) - 180, 50, 400, 100, "Paused");
  pauseMenuTitle.setFont(new Font("SansSerif", Font.PLAIN, 75));
  
  continueGameButton = new GButton(this, (width / 2) - 200, 350, 400, 100, "Continue Playing");
  continueGameButton.setFont(new Font("SansSerif", Font.PLAIN, 25));
  
  restartGameButton = new GButton(this, (width / 2) - 200, 500, 400, 100, "Restart Game (resets cube)");
  restartGameButton.setFont(new Font("SansSerif", Font.PLAIN, 25));
  
  goToSettingsMenuButton = new GButton(this, (width / 2) - 200, 650, 400, 100, "Settings");
  goToSettingsMenuButton.setFont(new Font("SansSerif", Font.PLAIN, 25));
  
  exitGameButton = new GButton(this, (width / 2) - 200, 800, 400, 100, "Exit Game");
  exitGameButton.setFont(new Font("SansSerif", Font.PLAIN, 25));
  
  setPauseMenuVisibility(false);
}

public void setPauseMenuVisibility(boolean value) {
  pauseMenuTitle.setVisible(value);
  continueGameButton.setVisible(value);
  restartGameButton.setVisible(value);
  exitGameButton.setVisible(value);
  goToSettingsMenuButton.setVisible(value);
}