/**
 * Třída CertifikatAct - dědí třídu Interaction.
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
import main.java.cz.vse.fanm02.adventure.main.logics.items.Certifikat;
import main.java.cz.vse.fanm02.adventure.main.logics.utils.Global;

public class CertifikatAct extends Interaction {

    public CertifikatAct() {
        super("Tisk", false, "Teď nemáš co bys vytiskl..", "Vytiskl jsi si Očkovací Certifikát, teď si ho můžeš vzít..");
    }

    @Override
    public boolean beforePick(Game game) {

        if (game.isVaccination()) {
            setAvailable(true);
            setTooltip("Jedna kopie ti stačí, nechceš přece plýtvat papírem");
        }
        return super.beforePick(game);
    }

    @Override
    public void afterPick(Game game) {
        game.setVaccination(false);
        Certifikat certifikat = new Certifikat();
        game.getCurrentRoom().addItem(certifikat);
        super.afterPick(game);
        Global.gamePrint("Předměty v místě: " + game.getCurrentRoom().getAllItemsText());
    }
}
