/**
 * Třída IsicAct - dědí třídu Interaction.
 * pro více info viz třídu Interaction
 *
 * Tato třída je součástí jednoduché textové hry.
 *
 * @author Martin Fanta
 * @version 1.0
 * @created říjen 2022
 */


package main.java.cz.vse.fanm02.adventure.main.logics.interactions;

import main.java.cz.vse.fanm02.adventure.main.logics.Game;
import main.java.cz.vse.fanm02.adventure.main.logics.items.Isic;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;


public class IsicAct extends Interaction {
    public IsicAct() {
        super("ISIC",
                false,
                "Pro zřízení ISICa potřebuješ fotku, nejdřív si zařiď fotku..",
                "Dobrá práce, teď je z tebe opravdový student\nVem si ISICa je na okýnku"
        );
    }

    private boolean used = false;

    @Override
    public boolean beforePick(Game game) {

        if (game.getBackpack().containsItemByName("Fotka") && !used) {
            this.setAvailable(true);
            this.setTooltip("Jeden ISIC ti bohatě stačí..");
        }

        return super.beforePick(game);
    }

    @Override
    public void afterPick(Game game) {
        Isic isic = new Isic();
        game.getCurrentRoom().addItem(isic);
        used = true;
        super.afterPick(game);
        Global.gamePrint("Předměty v místě: " + game.getCurrentRoom().getAllItemsText());
    }
}
