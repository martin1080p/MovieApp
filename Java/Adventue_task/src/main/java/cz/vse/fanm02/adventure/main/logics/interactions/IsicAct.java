package main.java.cz.vse.fanm02.adventure.main.logics.interactions;

import main.java.cz.vse.fanm02.adventure.main.logics.items.Fotak;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Fotka;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Item;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Isic extends Interaction {
    public Isic() {
        super("ISIC", false, Arrays.asList(new Fotka()), "Pro zřízení ISICa potřebuješ fotku, nejdřív si zařiď fotku..");
    }
}
