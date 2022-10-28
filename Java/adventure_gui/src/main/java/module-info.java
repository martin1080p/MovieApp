module cz.vse.java.fanm02.adventure_gui {
    requires javafx.controls;
    requires javafx.fxml;


    opens cz.vse.java.fanm02.adventure_gui to javafx.fxml;
    exports cz.vse.java.fanm02.adventure_gui;
}