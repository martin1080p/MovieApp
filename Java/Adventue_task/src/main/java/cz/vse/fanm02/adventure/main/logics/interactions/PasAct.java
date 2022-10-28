package main.java.cz.vse.fanm02.adventure.main.logics.interactions;

import main.java.cz.vse.fanm02.adventure.main.logics.items.Fotka;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Isic;

import java.util.Arrays;

public class Pas extends Interaction{
    public Pas(){
        super(  "Pas",
                false,
                Arrays.asList(new Fotka(), new Isic()),
                "Pro zřízení Pasu potřebuješ fotku, a ISICa.."
                );

    }
}
