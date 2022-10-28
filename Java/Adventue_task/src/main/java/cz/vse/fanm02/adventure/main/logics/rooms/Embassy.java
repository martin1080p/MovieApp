package main.java.cz.vse.fanm02.adventure.main.logics.rooms;

import main.java.cz.vse.fanm02.adventure.main.logics.items.Fotak;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Fotka;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Item;

import java.util.List;

public class Magistrat extends Room{
    public Magistrat(List<Room> otherRooms){
        super(  "Magistrát",
                new Item[]{},
                otherRooms,
                "");
    }
}
