/**
 * Třída VizumAct - dědí třídu Interaction.
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
import main.java.cz.vse.fanm02.adventure.main.logics.items.Vizum;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;

public class VizumAct extends Interaction {
    public VizumAct() {
        super("Vízum",
                false,
                "Pro zřízení Víza je potřeba mít propisku a doložit očkování..",
                "Úspěšně jsi si zřídil Vízum.."
        );
    }

    private boolean used = false;

    @Override
    public boolean beforePick(Game game) {
        if (game.getBackpack().containsItemByName("Propiska") && game.getBackpack().containsItemByName("Certifikát") && !used) {
            this.setAvailable(true);
        }

        return super.beforePick(game);
    }

    @Override
    public void afterPick(Game game) {
        used = true;
        Vizum vizum = new Vizum();
        game.getCurrentRoom().addItem(vizum);
        super.afterPick(game);
        Global.gamePrint("Předměty v místě: " + game.getCurrentRoom().getAllItemsText());
    }
}
