package main.java.cz.vse.fanm02.adventure.main.logics.interactions;

import main.java.cz.vse.fanm02.adventure.main.logics.items.Item;

import java.util.List;

public class Interaction {

    private String name;
    private List<Item> neededItems;
    private boolean isAvailable;

    private String disableText;

    public Interaction(String name, boolean isAvailable, List<Item> neededItems, String disableText){
        this.name = name;
        this.isAvailable = isAvailable;
        this.neededItems = neededItems;
        this.disableText = disableText;
    }

    public String getName() {
        return name;
    }

    public List<Item> getNeededItems() {
        return neededItems;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    @Override
    public String toString() {
        return name;
    }
}
