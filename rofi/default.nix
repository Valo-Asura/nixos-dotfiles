{ config, pkgs, ... }:

  {
 # programs.rofi = {
   # enable = true;
    #terminal = "${pkgs.cool-retro-term}/bin/cool-retro-term";
   # theme = ./theme.rasi;
  #};

  # You can also use `environment.etc` to place files directly if needed.
  home.file."./home/asura/.dotfiles/rofi/theme.rasi".text = ''
  
  /*****----- Configuration -----*****/
  configuration {
    modi:                       "drun,run,filebrowser,window";
    show-icons:                 true;
    display-drun:               "APPS";
    display-run:                "RUN";
    display-filebrowser:        "FILES";
    display-window:             "WINDOW";
    drun-display-format:        "{name}";
    window-format:              "{w} · {c} · {t}";
  }

  /*****----- Global Properties -----*****/
  * {
    font:                        "JetBrains Mono Nerd Font 10";
    background:                  #201A41;
    background-alt:              #392684;
    foreground:                  #FFFFFF;
    selected:                    #F801E8;
    active:                      #00CCF5;
    urgent:                      #8D0083;
  }

  /*****----- Main Window -----*****/
  window {
    transparency:                "real";
    location:                    center;
    anchor:                      center;
    fullscreen:                  false;
    width:                       1000px;
    x-offset:                    0px;
    y-offset:                    0px;
    border-radius:               15px;
    background-color:            @background;
  }

  mainbox {
    orientation:                 horizontal;
    children:                    [ "imagebox", "listbox" ];
  }

  imagebox {
    background-image:            url("./rofi/rofi.png", height);
    children:                    [ "inputbar", "dummy", "mode-switcher" ];
  }

  listbox {
    children:                    [ "message", "listview" ];
  }

  /*****----- Inputbar -----*****/
  inputbar {
    background-color:            @background-alt;
    children:                    [ "textbox-prompt-colon", "entry" ];
  }

  textbox-prompt-colon {
    str:                         "";
  }

  entry {
    placeholder:                 "Search";
  }

  /*****----- Mode Switcher -----*****/
  mode-switcher{
    background-color:            transparent;
    text-color:                  @foreground;
  }

  button {
    background-color:            @background-alt;
    text-color:                  inherit;
  }

  button selected {
    background-color:            @selected;
  }

  /*****----- Listview -----*****/
  listview {
    columns:                     1;
    lines:                       8;
    dynamic:                     true;
    scrollbar:                   false;
    background-color:            transparent;
    text-color:                  @foreground;
  }

  /*****----- Elements -----*****/
  element {
    background-color:            transparent;
    text-color:                  @foreground;
    cursor:                      pointer;
  }

  element selected.normal {
    background-color:            @selected;
  }
  
  element selected.urgent {
    background-color:            @urgent;
  }
  
  element selected.active {
    background-color:            @active;
  }

  '';
}
