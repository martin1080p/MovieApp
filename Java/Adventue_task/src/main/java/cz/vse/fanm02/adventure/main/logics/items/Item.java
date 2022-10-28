package main.java.cz.vse.fanm02.adventure.main.logics;

public class Item {

    private String name;
    private String tooltip;
    private boolean isInteractive;

    public Item(String name, boolean isInteractive, String... tooltip){
        this.name = name;
        this.isInteractive = isInteractive;
        if (tooltip.length > 0)
            this.tooltip = tooltip[0];
    }

    @Override
    public String toString(){
        return "name: " + this.name + ", isInteractive: " + this.isInteractive + ", tooltip: " + this.tooltip;
    }
}
