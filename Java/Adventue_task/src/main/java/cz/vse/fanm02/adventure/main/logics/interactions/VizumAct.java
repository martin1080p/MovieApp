package main.java.cz.vse.fanm02.adventure.main.logics.interactions;

import main.java.cz.vse.fanm02.adventure.main.logics.items.Fotka;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Isic;

import java.util.Arrays;

public class Vizum extends Interaction{
    public Vizum(){
        super(  "Vízum",
                false,
                Arrays.asList(new Fotka(), new Isic()),
                "Pro zřízení Víza potřebuješ doložit propisku a doložit očkování.."
        );
    }
}
