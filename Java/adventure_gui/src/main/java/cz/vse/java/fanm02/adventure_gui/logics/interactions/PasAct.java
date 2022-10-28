/**
 * Třída PasAct - dědí třídu Interaction.
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
import main.java.cz.vse.fanm02.adventure.main.logics.items.Pas;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;


public class PasAct extends Interaction {
    public PasAct() {
        super("Pas",
                false,
                "Pro zřízení Pasu potřebuješ fotku, a ISICa..",
                "Skvěle, máš nový pas, seber ho z přepážky!"
        );

    }

    private boolean used = false;

    @Override
    public boolean beforePick(Game game) {

        if (game.getBackpack().containsItemByName("Fotka") && game.getBackpack().containsItemByName("ISIC") && !used) {
            this.setAvailable(true);
            this.setTooltip("K čemu bys potřeboval 2 pasy???..");
        }
        return super.beforePick(game);
    }

    @Override
    public void afterPick(Game game) {
        Pas pas = new Pas();
        game.getCurrentRoom().addItem(pas);
        used = true;
        super.afterPick(game);
        Global.gamePrint("Předměty v místě: " + game.getCurrentRoom().getAllItemsText());
    }
}
