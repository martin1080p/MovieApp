package main.java.cz.vse.fanm02.adventure.main.logics.interactions;

import main.java.cz.vse.fanm02.adventure.main.logics.items.Certifikat;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Fotka;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Isic;

import java.util.Arrays;

public class Letenka extends Interaction{

    public Letenka(){
        super(  "Letenka",
                false,
                Arrays.asList(new Certifikat()),
                "Abys mohl získat letenku, potřebuješ mít vytištěné ověření o očkování na Covid-19.."
        );

    }
}
